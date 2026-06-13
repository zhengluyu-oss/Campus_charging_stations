<template>
  <div ref="containerRef" class="hand-particle-canvas">
    <video ref="videoRef" class="hidden-video" playsinline></video>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onBeforeUnmount } from 'vue'
import * as THREE from 'three'

// MediaPipe packages are Closure-compiled IIFEs that attach to window.
// Importing them triggers the side-effect (global registration).
import '@mediapipe/hands'
import '@mediapipe/camera_utils'

// ---------------------------------------------------------------------------
// Emits
// ---------------------------------------------------------------------------
const emit = defineEmits<{
  'hand-detected': [position: { x: number; y: number }]
  'hand-lost': []
}>()

// ---------------------------------------------------------------------------
// Template refs
// ---------------------------------------------------------------------------
const containerRef = ref<HTMLDivElement>()
const videoRef = ref<HTMLVideoElement>()

// ---------------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------------
const PARTICLE_COUNT = 2000
const ATTRACTION_RADIUS = 200
const EXPLOSION_RADIUS = 300
const ORBIT_RADIUS = 250
const PINCH_THRESHOLD = 0.06
const SPREAD_THRESHOLD = 0.18

// Color palette (cyan -> green gradient)
const COLOR_CYAN = { r: 0.0, g: 0.788, b: 1.0 }
const COLOR_GREEN = { r: 0.573, g: 1.0, b: 0.616 }

// ---------------------------------------------------------------------------
// Three.js state
// ---------------------------------------------------------------------------
let scene: THREE.Scene
let camera: THREE.OrthographicCamera
let renderer: THREE.WebGLRenderer
let particleSystem: THREE.Points
let geometry: THREE.BufferGeometry
let animationId = 0
let clock: THREE.Clock

// Per-particle GPU attributes
let positions: Float32Array
let colors: Float32Array
let sizes: Float32Array
let alphas: Float32Array

// Per-particle CPU-only physics state
let velX: Float32Array
let velY: Float32Array
let lives: Float32Array
let maxLives: Float32Array

// ---------------------------------------------------------------------------
// Hand tracking state
// ---------------------------------------------------------------------------
let handActive = false
let handX = 0
let handY = 0
let prevHandX = 0
let prevHandY = 0
let handVelX = 0
let handVelY = 0
let isPinching = false
let isSpreading = false

// MediaPipe instances (typed loosely -- package ships its own .d.ts but
// the shapes are volatile across minor versions)
// eslint-disable-next-line @typescript-eslint/no-explicit-any
let mpHands: any = null
// eslint-disable-next-line @typescript-eslint/no-explicit-any
let mpCamera: any = null

// ---------------------------------------------------------------------------
// Screen dimensions (updated on resize)
// ---------------------------------------------------------------------------
let width = window.innerWidth
let height = window.innerHeight

// =====================================================================
//  THREE.JS INITIALISATION
// =====================================================================
function initThreeJS() {
  scene = new THREE.Scene()

  camera = new THREE.OrthographicCamera(0, width, 0, height, -1, 1)
  camera.position.z = 1

  renderer = new THREE.WebGLRenderer({ alpha: true })
  renderer.setSize(width, height)
  renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))
  renderer.domElement.style.position = 'absolute'
  renderer.domElement.style.top = '0'
  renderer.domElement.style.left = '0'

  if (containerRef.value) {
    containerRef.value.appendChild(renderer.domElement)
  }

  clock = new THREE.Clock()
}

// =====================================================================
//  PARTICLE INITIALISATION
// =====================================================================
function initParticles() {
  positions = new Float32Array(PARTICLE_COUNT * 3)
  colors = new Float32Array(PARTICLE_COUNT * 3)
  sizes = new Float32Array(PARTICLE_COUNT)
  alphas = new Float32Array(PARTICLE_COUNT)
  velX = new Float32Array(PARTICLE_COUNT)
  velY = new Float32Array(PARTICLE_COUNT)
  lives = new Float32Array(PARTICLE_COUNT)
  maxLives = new Float32Array(PARTICLE_COUNT)

  for (let i = 0; i < PARTICLE_COUNT; i++) {
    resetParticle(i, true)
  }

  geometry = new THREE.BufferGeometry()
  geometry.setAttribute('position', new THREE.Float32BufferAttribute(positions, 3))
  geometry.setAttribute('color', new THREE.Float32BufferAttribute(colors, 3))
  geometry.setAttribute('aSize', new THREE.Float32BufferAttribute(sizes, 1))
  geometry.setAttribute('aAlpha', new THREE.Float32BufferAttribute(alphas, 1))

  const material = new THREE.ShaderMaterial({
    vertexShader: `
      attribute float aSize;
      attribute float aAlpha;
      varying vec3 vColor;
      varying float vAlpha;
      void main() {
        vColor = color;
        vAlpha = aAlpha;
        gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
        gl_PointSize = aSize;
      }
    `,
    fragmentShader: `
      varying vec3 vColor;
      varying float vAlpha;
      void main() {
        vec2 uv = gl_PointCoord - vec2(0.5);
        float dist = length(uv);
        if (dist > 0.5) discard;
        float glow = smoothstep(0.5, 0.0, dist);
        gl_FragColor = vec4(vColor, glow * vAlpha);
      }
    `,
    transparent: true,
    depthWrite: false,
    vertexColors: true,
    blending: THREE.AdditiveBlending,
  })

  particleSystem = new THREE.Points(geometry, material)
  scene.add(particleSystem)
}

/** Reset (or initialise) a single particle. */
function resetParticle(i: number, randomLife: boolean) {
  const ix = i * 3

  positions[ix] = Math.random() * width
  positions[ix + 1] = Math.random() * height
  positions[ix + 2] = 0

  // Random colour on the cyan-green gradient
  const t = Math.random()
  colors[ix] = COLOR_CYAN.r + t * (COLOR_GREEN.r - COLOR_CYAN.r)
  colors[ix + 1] = COLOR_CYAN.g + t * (COLOR_GREEN.g - COLOR_CYAN.g)
  colors[ix + 2] = COLOR_CYAN.b + t * (COLOR_GREEN.b - COLOR_CYAN.b)

  sizes[i] = Math.random() * 4 + 1

  velX[i] = (Math.random() - 0.5) * 0.6
  velY[i] = (Math.random() - 0.5) * 0.6

  maxLives[i] = Math.random() * 4 + 2
  lives[i] = randomLife ? Math.random() * maxLives[i] : maxLives[i]
  alphas[i] = 0
}

// =====================================================================
//  MEDIAPIPE INITIALISATION
// =====================================================================
async function initMediaPipe() {
  if (!videoRef.value) return

  try {
    // Access constructors from the global scope (set by the IIFE side-effect imports)
    const HandsCtor = (window as any).Hands
    const CameraCtor = (window as any).Camera

    if (!HandsCtor || !CameraCtor) {
      console.warn('MediaPipe globals not found – running in ambient mode.')
      return
    }

    mpHands = new HandsCtor({
      locateFile: (file: string) =>
        `https://cdn.jsdelivr.net/npm/@mediapipe/hands/${file}`,
    })

    mpHands.setOptions({
      maxNumHands: 2,
      modelComplexity: 1,
      minDetectionConfidence: 0.6,
      minTrackingConfidence: 0.5,
    })

    mpHands.onResults(onHandResults)

    mpCamera = new CameraCtor(videoRef.value, {
      onFrame: async () => {
        if (mpHands && videoRef.value) {
          await mpHands.send({ image: videoRef.value })
        }
      },
      width: 640,
      height: 480,
    })

    await mpCamera.start()
  } catch (err) {
    console.warn('Hand tracking unavailable – running in ambient mode.', err)
  }
}

// =====================================================================
//  MEDIAPIPE RESULTS CALLBACK
// =====================================================================
function onHandResults(results: { multiHandLandmarks?: { x: number; y: number }[][] }) {
  if (results.multiHandLandmarks && results.multiHandLandmarks.length > 0) {
    const lm = results.multiHandLandmarks[0]

    // Store previous position for velocity
    prevHandX = handX
    prevHandY = handY

    // Index finger tip (landmark 8) -> screen coords
    const tip = lm[8]
    handX = tip.x * width
    handY = tip.y * height

    handVelX = handX - prevHandX
    handVelY = handY - prevHandY

    // Pinch: thumb tip (4) close to index tip (8)
    const thumb = lm[4]
    const pinchDist = Math.hypot(tip.x - thumb.x, tip.y - thumb.y)
    isPinching = pinchDist < PINCH_THRESHOLD

    // Spread: index tip (8) far from pinky tip (20)
    const pinky = lm[20]
    const spreadDist = Math.hypot(tip.x - pinky.x, tip.y - pinky.y)
    isSpreading = spreadDist > SPREAD_THRESHOLD && !isPinching

    if (!handActive) {
      handActive = true
      emit('hand-detected', { x: handX, y: handY })
    }
  } else {
    if (handActive) {
      handActive = false
      isPinching = false
      isSpreading = false
      emit('hand-lost')
    }
  }
}

// =====================================================================
//  ANIMATION LOOP
// =====================================================================
function animate() {
  animationId = requestAnimationFrame(animate)
  const delta = Math.min(clock.getDelta(), 0.05)

  updateParticles(delta)

  const posAttr = geometry.getAttribute('position') as THREE.BufferAttribute
  const alphaAttr = geometry.getAttribute('aAlpha') as THREE.BufferAttribute
  posAttr.needsUpdate = true
  alphaAttr.needsUpdate = true

  renderer.render(scene, camera)
}

// =====================================================================
//  PARTICLE PHYSICS UPDATE
// =====================================================================
function updateParticles(delta: number) {
  const dt60 = delta * 60 // normalise to 60 fps for frame-rate independence

  for (let i = 0; i < PARTICLE_COUNT; i++) {
    // ---- lifetime ----
    lives[i] -= delta / maxLives[i]
    if (lives[i] <= 0) {
      respawnParticle(i)
      continue
    }

    const ix = i * 3

    // ---- hand interactions ----
    if (handActive) {
      const dx = handX - positions[ix]
      const dy = handY - positions[ix + 1]
      const dist = Math.sqrt(dx * dx + dy * dy)

      if (isPinching && dist < EXPLOSION_RADIUS && dist > 1) {
        // EXPLODE outward
        const force = (1 - dist / EXPLOSION_RADIUS) * 10
        velX[i] -= (dx / dist) * force * dt60
        velY[i] -= (dy / dist) * force * dt60
      } else if (!isPinching && dist < ATTRACTION_RADIUS && dist > 1) {
        // ATTRACT toward fingertip
        const force = (1 - dist / ATTRACTION_RADIUS) * 4
        velX[i] += (dx / dist) * force * dt60
        velY[i] += (dy / dist) * force * dt60
      }

      if (isSpreading && dist < ORBIT_RADIUS && dist > 20) {
        // ORBIT tangentially
        const angle = Math.atan2(dy, dx) + Math.PI * 0.5
        const orbitForce = 2.5
        velX[i] += Math.cos(angle) * orbitForce * dt60
        velY[i] += Math.sin(angle) * orbitForce * dt60
      }
    }

    // ---- tiny ambient drift ----
    velX[i] += (Math.random() - 0.5) * 0.015 * dt60
    velY[i] += (Math.random() - 0.5) * 0.015 * dt60

    // ---- integrate velocity ----
    positions[ix] += velX[i]
    positions[ix + 1] += velY[i]

    // ---- damping ----
    velX[i] *= 0.97
    velY[i] *= 0.97

    // ---- wrap at screen edges ----
    if (positions[ix] < -10) positions[ix] = width + 10
    else if (positions[ix] > width + 10) positions[ix] = -10
    if (positions[ix + 1] < -10) positions[ix + 1] = height + 10
    else if (positions[ix + 1] > height + 10) positions[ix + 1] = -10

    // ---- alpha: fade in then out over lifetime ----
    const lifeRatio = lives[i] / maxLives[i]
    alphas[i] = Math.sin(lifeRatio * Math.PI) * 0.75
  }

  // ---- trail emission when hand moves ----
  if (handActive) {
    const speed = Math.hypot(handVelX, handVelY)
    if (speed > 3) {
      const count = Math.min(Math.floor(speed / 4), 6)
      for (let t = 0; t < count; t++) {
        emitTrailParticle()
      }
    }
  }
}

// =====================================================================
//  PARTICLE RESPAWN
// =====================================================================
function respawnParticle(i: number) {
  const ix = i * 3

  // 30 % chance to respawn near the hand if it is active
  if (handActive && Math.random() < 0.3) {
    const spread = 50
    positions[ix] = handX + (Math.random() - 0.5) * spread
    positions[ix + 1] = handY + (Math.random() - 0.5) * spread
  } else {
    positions[ix] = Math.random() * width
    positions[ix + 1] = Math.random() * height
  }
  positions[ix + 2] = 0

  velX[i] = (Math.random() - 0.5) * 0.8
  velY[i] = (Math.random() - 0.5) * 0.8

  const t = Math.random()
  colors[ix] = COLOR_CYAN.r + t * (COLOR_GREEN.r - COLOR_CYAN.r)
  colors[ix + 1] = COLOR_CYAN.g + t * (COLOR_GREEN.g - COLOR_CYAN.g)
  colors[ix + 2] = COLOR_CYAN.b + t * (COLOR_GREEN.b - COLOR_CYAN.b)

  sizes[i] = Math.random() * 4 + 1
  lives[i] = 1.0
  maxLives[i] = Math.random() * 4 + 2
}

// =====================================================================
//  TRAIL EMISSION
// =====================================================================
function emitTrailParticle() {
  // Find the dead particle or the one closest to death
  let idx = 0
  let minLife = Infinity
  for (let i = 0; i < PARTICLE_COUNT; i++) {
    if (lives[i] <= 0) { idx = i; break }
    if (lives[i] < minLife) { minLife = lives[i]; idx = i }
  }

  const i = idx
  const ix = i * 3

  positions[ix] = handX + (Math.random() - 0.5) * 24
  positions[ix + 1] = handY + (Math.random() - 0.5) * 24
  positions[ix + 2] = 0

  // Velocity: hand direction + random spread
  const speed = Math.hypot(handVelX, handVelY)
  const angle = Math.atan2(handVelY, handVelX) + (Math.random() - 0.5) * Math.PI
  velX[i] = Math.cos(angle) * speed * 0.25 + (Math.random() - 0.5) * 2
  velY[i] = Math.sin(angle) * speed * 0.25 + (Math.random() - 0.5) * 2

  // Bright cyan for trail particles
  colors[ix] = 0
  colors[ix + 1] = 0.8 + Math.random() * 0.2
  colors[ix + 2] = 1.0

  sizes[i] = Math.random() * 5 + 2
  lives[i] = 1.0
  maxLives[i] = Math.random() * 1.5 + 0.8
}

// =====================================================================
//  RESIZE HANDLER
// =====================================================================
function handleResize() {
  width = window.innerWidth
  height = window.innerHeight

  camera.right = width
  camera.bottom = height
  camera.updateProjectionMatrix()

  renderer.setSize(width, height)
}

// =====================================================================
//  LIFECYCLE
// =====================================================================
onMounted(() => {
  initThreeJS()
  initParticles()
  animate()
  initMediaPipe()
  window.addEventListener('resize', handleResize)
})

onBeforeUnmount(() => {
  // Stop animation
  if (animationId) cancelAnimationFrame(animationId)

  // Stop MediaPipe camera
  if (mpCamera) {
    mpCamera.stop()
    mpCamera = null
  }
  if (mpHands) {
    mpHands.close()
    mpHands = null
  }

  // Dispose Three.js resources
  if (geometry) geometry.dispose()
  if (particleSystem) {
    ;(particleSystem.material as THREE.Material).dispose()
    scene.remove(particleSystem)
  }
  if (renderer) {
    renderer.dispose()
    renderer.domElement.remove()
  }

  window.removeEventListener('resize', handleResize)
})
</script>

<style scoped>
.hand-particle-canvas {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  pointer-events: none;
  z-index: 0;
  overflow: hidden;
}

.hidden-video {
  position: absolute;
  width: 1px;
  height: 1px;
  opacity: 0;
  pointer-events: none;
}
</style>
