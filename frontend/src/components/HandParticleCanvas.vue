<template>
  <video ref="videoRef" style="display: none" playsinline autoplay muted></video>
  <canvas ref="canvasRef"></canvas>
  <button
    class="camera-toggle"
    :class="{ active: cameraActive }"
    :title="cameraActive ? 'Disable camera' : 'Enable camera'"
    @click="toggleCamera"
  >
    <svg
      xmlns="http://www.w3.org/2000/svg"
      width="24"
      height="24"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      stroke-width="2"
      stroke-linecap="round"
      stroke-linejoin="round"
    >
      <path
        v-if="!cameraActive"
        d="M23 7l-7 5 7 5V7z"
      />
      <path
        v-if="!cameraActive"
        d="M1 5h15a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H1z"
      />
      <g v-if="cameraActive">
        <path d="M23 7l-7 5 7 5V7z" />
        <rect x="1" y="5" width="15" height="14" rx="2" ry="2" />
        <line x1="1" y1="1" x2="23" y2="23" stroke="red" />
      </g>
    </svg>
    <span class="status-dot" :class="{ on: cameraActive }"></span>
  </button>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import * as THREE from 'three'

// ---------------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------------
const PARTICLE_COUNT = 3000
const ATTRACT_RADIUS = 250
const ATTRACT_STRENGTH = 0.03
const LIFE_DECAY = 0.003
const PINCH_THRESHOLD = 0.05
const SPREAD_THRESHOLD = 0.15
const TRAIL_PARTICLES_PER_FRAME = 5
const EXPLODE_BURST_COUNT = 50

// Cyan-to-green palette values
const COLOR_CYAN = new THREE.Color('#00c9ff')
const COLOR_GREEN = new THREE.Color('#92fe9d')
const COLOR_WHITE = new THREE.Color('#ffffff')

// ---------------------------------------------------------------------------
// Refs
// ---------------------------------------------------------------------------
const videoRef = ref<HTMLVideoElement | null>(null)
const canvasRef = ref<HTMLCanvasElement | null>(null)
const cameraActive = ref(false)

// ---------------------------------------------------------------------------
// Internal state (not reactive – no need for Vue reactivity)
// ---------------------------------------------------------------------------
let scene: THREE.Scene
let orthoCamera: THREE.OrthographicCamera
let renderer: THREE.WebGLRenderer
let particleSystem: THREE.Points
let geometry: THREE.BufferGeometry
let material: THREE.ShaderMaterial

// Particle attribute arrays
let posArray: Float32Array
let velArray: Float32Array
let colArray: Float32Array
let sizeArray: Float32Array
let lifeArray: Float32Array

// Hand tracking
let hands: any = null
let mpCamera: any = null
let handPosition: { x: number; y: number } | null = null
let prevHandPosition: { x: number; y: number } | null = null
let isPinching = false
let fingersSpread = false

// Animation
let animFrameId: number | null = null
let clock: THREE.Clock

// ---------------------------------------------------------------------------
// Three.js initialisation
// ---------------------------------------------------------------------------
function initThree(): void {
  scene = new THREE.Scene()

  const w = window.innerWidth
  const h = window.innerHeight
  orthoCamera = new THREE.OrthographicCamera(0, w, 0, h, -1, 1)
  orthoCamera.position.z = 1

  renderer = new THREE.WebGLRenderer({ alpha: true, antialias: true })
  renderer.setSize(w, h)
  renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))
  renderer.setClearColor(0x000000, 0)

  // Style the renderer canvas to be a fixed overlay
  const cvs = renderer.domElement
  cvs.style.position = 'fixed'
  cvs.style.top = '0'
  cvs.style.left = '0'
  cvs.style.width = '100vw'
  cvs.style.height = '100vh'
  cvs.style.pointerEvents = 'none'
  cvs.style.zIndex = '0'
  document.body.appendChild(cvs)

  // Hide the template canvas – we use the renderer's own canvas
  if (canvasRef.value) {
    canvasRef.value.style.display = 'none'
  }

  clock = new THREE.Clock()

  initParticles()
}

// ---------------------------------------------------------------------------
// Particle system
// ---------------------------------------------------------------------------
function initParticles(): void {
  geometry = new THREE.BufferGeometry()

  posArray = new Float32Array(PARTICLE_COUNT * 3)
  velArray = new Float32Array(PARTICLE_COUNT * 3)
  colArray = new Float32Array(PARTICLE_COUNT * 3)
  sizeArray = new Float32Array(PARTICLE_COUNT)
  lifeArray = new Float32Array(PARTICLE_COUNT)

  const w = window.innerWidth
  const h = window.innerHeight

  for (let i = 0; i < PARTICLE_COUNT; i++) {
    resetParticle(i, Math.random() * w, Math.random() * h)
  }

  geometry.setAttribute('position', new THREE.BufferAttribute(posArray, 3))
  geometry.setAttribute('aVelocity', new THREE.BufferAttribute(velArray, 3))
  geometry.setAttribute('aColor', new THREE.BufferAttribute(colArray, 3))
  geometry.setAttribute('aSize', new THREE.BufferAttribute(sizeArray, 1))
  geometry.setAttribute('aLife', new THREE.BufferAttribute(lifeArray, 1))

  material = new THREE.ShaderMaterial({
    uniforms: {
      uTime: { value: 0 },
    },
    vertexShader: `
      attribute float aSize;
      attribute vec3 aColor;
      attribute float aLife;
      varying vec3 vColor;
      varying float vLife;

      void main() {
        vColor = aColor;
        vLife = aLife;
        vec4 mvPosition = modelViewMatrix * vec4(position, 1.0);
        gl_PointSize = aSize * (1.0 + 0.3 * sin(aLife * 6.2831));
        gl_Position = projectionMatrix * mvPosition;
      }
    `,
    fragmentShader: `
      varying vec3 vColor;
      varying float vLife;

      void main() {
        // Circular point with soft glow
        vec2 uv = gl_PointCoord - vec2(0.5);
        float dist = length(uv);
        if (dist > 0.5) discard;

        float alpha = smoothstep(0.5, 0.0, dist) * vLife;
        gl_FragColor = vec4(vColor, alpha);
      }
    `,
    transparent: true,
    blending: THREE.AdditiveBlending,
    depthWrite: false,
  })

  particleSystem = new THREE.Points(geometry, material)
  scene.add(particleSystem)
}

function resetParticle(i: number, x?: number, y?: number): void {
  const w = window.innerWidth
  const h = window.innerHeight

  const ix = i * 3
  posArray[ix] = x ?? Math.random() * w
  posArray[ix + 1] = y ?? Math.random() * h
  posArray[ix + 2] = 0

  velArray[ix] = (Math.random() - 0.5) * 2
  velArray[ix + 1] = (Math.random() - 0.5) * 2
  velArray[ix + 2] = 0

  // Color: blend between cyan and green, with occasional white sparkle
  const t = Math.random()
  const c = new THREE.Color()
  if (Math.random() < 0.05) {
    // White sparkle
    c.copy(COLOR_WHITE)
  } else {
    c.lerpColors(COLOR_CYAN, COLOR_GREEN, t)
  }
  colArray[ix] = c.r
  colArray[ix + 1] = c.g
  colArray[ix + 2] = c.b

  sizeArray[i] = 1.0 + Math.random() * 3.0 // 1.0 – 4.0
  lifeArray[i] = 0.3 + Math.random() * 0.7  // 0.3 – 1.0
}

function spawnParticle(x: number, y: number, vx: number, vy: number, life: number): void {
  // Find a dead particle or reuse the oldest
  let idx = -1
  for (let i = 0; i < PARTICLE_COUNT; i++) {
    if (lifeArray[i] <= 0) {
      idx = i
      break
    }
  }
  if (idx === -1) {
    // All alive – pick random one to overwrite
    idx = Math.floor(Math.random() * PARTICLE_COUNT)
  }

  const ix = idx * 3
  posArray[ix] = x
  posArray[ix + 1] = y
  posArray[ix + 2] = 0

  velArray[ix] = vx
  velArray[ix + 1] = vy
  velArray[ix + 2] = 0

  const t = Math.random()
  const c = new THREE.Color()
  if (Math.random() < 0.1) {
    c.copy(COLOR_WHITE)
  } else {
    c.lerpColors(COLOR_CYAN, COLOR_GREEN, t)
  }
  colArray[ix] = c.r
  colArray[ix + 1] = c.g
  colArray[ix + 2] = c.b

  sizeArray[idx] = 2.0 + Math.random() * 4.0
  lifeArray[idx] = life
}

// ---------------------------------------------------------------------------
// Hand tracking initialisation
// ---------------------------------------------------------------------------
async function initHandTracking(): Promise<void> {
  if (!videoRef.value) return

  // Dynamic imports to avoid Vite CJS/ESM issues
  const handsModule = await import('@mediapipe/hands')
  const cameraModule = await import('@mediapipe/camera_utils')
  const Hands = handsModule.Hands ?? handsModule.default?.Hands
  const Camera = cameraModule.Camera ?? cameraModule.default?.Camera

  if (!Hands || !Camera) {
    console.warn('MediaPipe modules not available')
    return
  }

  hands = new Hands({
    locateFile: (file: string) => {
      return `https://cdn.jsdelivr.net/npm/@mediapipe/hands/${file}`
    },
  })

  hands.setOptions({
    maxNumHands: 2,
    modelComplexity: 1,
    minDetectionConfidence: 0.7,
    minTrackingConfidence: 0.5,
  })

  hands.onResults(onHandResults)

  try {
    const stream = await navigator.mediaDevices.getUserMedia({
      video: { width: 640, height: 480, facingMode: 'user' },
    })
    videoRef.value.srcObject = stream

    mpCamera = new Camera(videoRef.value, {
      onFrame: async () => {
        if (hands && videoRef.value) {
          await hands.send({ image: videoRef.value })
        }
      },
      width: 640,
      height: 480,
    })
    await mpCamera.start()
    cameraActive.value = true
  } catch (err) {
    console.warn('Camera permission denied or unavailable:', err)
    cameraActive.value = false
    // Continue with ambient particles – no error to the user
  }
}

function stopHandTracking(): void {
  if (mpCamera) {
    mpCamera.stop()
    mpCamera = null
  }
  if (videoRef.value && videoRef.value.srcObject) {
    const tracks = (videoRef.value.srcObject as MediaStream).getTracks()
    tracks.forEach((t) => t.stop())
    videoRef.value.srcObject = null
  }
  if (hands) {
    hands.close()
    hands = null
  }
  handPosition = null
  prevHandPosition = null
  cameraActive.value = false
}

// ---------------------------------------------------------------------------
// Hand results callback
// ---------------------------------------------------------------------------
function onHandResults(results: any): void {
  if (results.multiHandLandmarks && results.multiHandLandmarks.length > 0) {
    const landmarks = results.multiHandLandmarks[0]
    const indexTip = landmarks[8]
    const thumbTip = landmarks[4]

    // Mirror X for selfie view
    const hx = (1 - indexTip.x) * window.innerWidth
    const hy = indexTip.y * window.innerHeight

    prevHandPosition = handPosition ? { ...handPosition } : null
    handPosition = { x: hx, y: hy }

    // Pinch detection: distance between thumb tip and index tip
    const dx = thumbTip.x - indexTip.x
    const dy = thumbTip.y - indexTip.y
    const pinchDist = Math.sqrt(dx * dx + dy * dy)
    isPinching = pinchDist < PINCH_THRESHOLD

    // Spread fingers detection: average distance between fingertips
    const tips = [landmarks[4], landmarks[8], landmarks[12], landmarks[16], landmarks[20]]
    let totalDist = 0
    let count = 0
    for (let i = 0; i < tips.length; i++) {
      for (let j = i + 1; j < tips.length; j++) {
        const sdx = tips[i].x - tips[j].x
        const sdy = tips[i].y - tips[j].y
        totalDist += Math.sqrt(sdx * sdx + sdy * sdy)
        count++
      }
    }
    fingersSpread = totalDist / count > SPREAD_THRESHOLD
  } else {
    prevHandPosition = handPosition
    handPosition = null
    isPinching = false
    fingersSpread = false
  }
}

// ---------------------------------------------------------------------------
// Animation loop
// ---------------------------------------------------------------------------
function animate(): void {
  animFrameId = requestAnimationFrame(animate)

  const time = clock.getElapsedTime()
  material.uniforms.uTime.value = time

  const w = window.innerWidth
  const h = window.innerHeight

  for (let i = 0; i < PARTICLE_COUNT; i++) {
    const ix = i * 3
    let px = posArray[ix]
    let py = posArray[ix + 1]
    let vx = velArray[ix]
    let vy = velArray[ix + 1]
    let life = lifeArray[i]

    if (handPosition) {
      // ---- HAND DETECTED MODE ----
      const dx = handPosition.x - px
      const dy = handPosition.y - py
      const dist = Math.sqrt(dx * dx + dy * dy)

      if (dist < ATTRACT_RADIUS) {
        // Attract toward hand
        const strength = ATTRACT_STRENGTH * (1 - dist / ATTRACT_RADIUS)
        vx += dx * strength
        vy += dy * strength

        // Glow brighter near hand
        const proximity = 1 - dist / ATTRACT_RADIUS
        sizeArray[i] = Math.min(sizeArray[i] + proximity * 0.1, 12.0)
        lifeArray[i] = Math.min(lifeArray[i] + proximity * 0.01, 1.0)
      }

      // Spiral orbit when fingers are spread
      if (fingersSpread && dist < ATTRACT_RADIUS) {
        const angle = Math.atan2(dy, dx) + 0.1
        const orbitSpeed = 2.0
        vx += Math.cos(angle) * orbitSpeed * 0.05
        vy += Math.sin(angle) * orbitSpeed * 0.05
      }
    } else {
      // ---- AMBIENT MODE ----
      // Gentle drift
      vx += (Math.random() - 0.5) * 0.02
      vy += (Math.random() - 0.5) * 0.02

      // Sine wave oscillation on Y
      vy += Math.sin(time * 2 + px * 0.01) * 0.02

      // Damping
      vx *= 0.99
      vy *= 0.99
    }

    // Apply velocity
    px += vx
    py += vy

    // Wrap around screen edges
    if (px < 0) px += w
    if (px > w) px -= w
    if (py < 0) py += h
    if (py > h) py -= h

    // Life decay
    life -= LIFE_DECAY

    // Respawn dead particles
    if (life <= 0) {
      resetParticle(i)
    } else {
      posArray[ix] = px
      posArray[ix + 1] = py
      velArray[ix] = vx
      velArray[ix + 1] = vy
      lifeArray[i] = life
    }
  }

  // Handle pinch explosion
  if (isPinching && handPosition) {
    for (let j = 0; j < EXPLODE_BURST_COUNT; j++) {
      const angle = Math.random() * Math.PI * 2
      const speed = 3 + Math.random() * 8
      spawnParticle(
        handPosition.x,
        handPosition.y,
        Math.cos(angle) * speed,
        Math.sin(angle) * speed,
        0.5 + Math.random() * 0.3,
      )
    }
    isPinching = false // Only burst once per pinch detection
  }

  // Hand trail particles
  if (handPosition && prevHandPosition) {
    const trailDx = handPosition.x - prevHandPosition.x
    const trailDy = handPosition.y - prevHandPosition.y
    const speed = Math.sqrt(trailDx * trailDx + trailDy * trailDy)
    if (speed > 3) {
      for (let j = 0; j < TRAIL_PARTICLES_PER_FRAME; j++) {
        const t = Math.random()
        spawnParticle(
          prevHandPosition.x + trailDx * t + (Math.random() - 0.5) * 20,
          prevHandPosition.y + trailDy * t + (Math.random() - 0.5) * 20,
          trailDx * 0.1 + (Math.random() - 0.5) * 2,
          trailDy * 0.1 + (Math.random() - 0.5) * 2,
          0.4 + Math.random() * 0.3,
        )
      }
    }
  }

  // Mark buffers dirty
  geometry.attributes.position.needsUpdate = true
  geometry.attributes.aVelocity.needsUpdate = true
  geometry.attributes.aColor.needsUpdate = true
  geometry.attributes.aSize.needsUpdate = true
  geometry.attributes.aLife.needsUpdate = true

  renderer.render(scene, orthoCamera)
}

// ---------------------------------------------------------------------------
// Camera toggle
// ---------------------------------------------------------------------------
async function toggleCamera(): Promise<void> {
  if (cameraActive.value) {
    stopHandTracking()
  } else {
    await initHandTracking()
  }
}

// ---------------------------------------------------------------------------
// Resize handler
// ---------------------------------------------------------------------------
function onResize(): void {
  const w = window.innerWidth
  const h = window.innerHeight

  orthoCamera.right = w
  orthoCamera.bottom = h
  orthoCamera.updateProjectionMatrix()

  renderer.setSize(w, h)
}

// ---------------------------------------------------------------------------
// Lifecycle
// ---------------------------------------------------------------------------
onMounted(() => {
  try {
    initThree()
    animate()
    window.addEventListener('resize', onResize)
  } catch (e) {
    console.warn('HandParticleCanvas init failed:', e)
  }
})

onUnmounted(() => {
  // Stop animation
  if (animFrameId !== null) {
    cancelAnimationFrame(animFrameId)
    animFrameId = null
  }

  // Stop camera / MediaPipe
  stopHandTracking()

  // Remove renderer canvas from DOM
  if (renderer) {
    const cvs = renderer.domElement
    if (cvs.parentNode) {
      cvs.parentNode.removeChild(cvs)
    }
    renderer.dispose()
  }

  // Dispose geometry and material
  if (geometry) geometry.dispose()
  if (material) material.dispose()

  // Remove resize listener
  window.removeEventListener('resize', onResize)
})
</script>

<style scoped>
canvas {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  pointer-events: none;
  z-index: 0;
}

.camera-toggle {
  position: fixed;
  bottom: 20px;
  right: 20px;
  z-index: 1000;
  width: 50px;
  height: 50px;
  border-radius: 50%;
  border: 1px solid rgba(255, 255, 255, 0.2);
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  color: #ccc;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
  padding: 0;
}

.camera-toggle:hover {
  background: rgba(255, 255, 255, 0.2);
  color: #fff;
  border-color: rgba(255, 255, 255, 0.4);
}

.camera-toggle.active {
  background: rgba(0, 201, 255, 0.2);
  border-color: rgba(0, 201, 255, 0.5);
  color: #00c9ff;
}

.status-dot {
  position: absolute;
  bottom: 4px;
  right: 4px;
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: #666;
  transition: background 0.3s ease;
}

.status-dot.on {
  background: #00ff88;
  box-shadow: 0 0 6px #00ff88;
}
</style>
