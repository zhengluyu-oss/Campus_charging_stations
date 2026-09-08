<template>
  <canvas ref="canvasRef" class="ambient-canvas" aria-hidden="true"></canvas>
</template>

<script setup lang="ts">
import { computed, onMounted, onUnmounted, ref, watch } from 'vue'
import { useEffectsOptional, type AmbientPreset, type EffectsLevel } from './effectsContext'

interface Particle {
  x: number
  y: number
  vx: number
  vy: number
  size: number
}

const props = withDefaults(
  defineProps<{
    preset?: AmbientPreset
  }>(),
  { preset: undefined }
)

const effects = useEffectsOptional()
const canvasRef = ref<HTMLCanvasElement | null>(null)

let particles: Particle[] = []
let animationId: number | null = null
let canvasWidth = 0
let canvasHeight = 0
let ctx: CanvasRenderingContext2D | null = null

const activeLevel = computed<EffectsLevel>(() => effects?.level.value ?? 'full')
const activePreset = computed<AmbientPreset>(() => {
  if (props.preset) return props.preset
  return effects?.ambientPreset.value ?? 'medium'
})

function densityFor(level: EffectsLevel, preset: AmbientPreset): number {
  if (level === 'off' || preset === 'none') return 0
  const base = level === 'low' ? 0.45 : 1
  const map: Record<AmbientPreset, number> = {
    none: 0,
    weak: 40,
    medium: 90,
    strong: 140,
  }
  return Math.round(map[preset] * base)
}

function speedFor(level: EffectsLevel, preset: AmbientPreset): number {
  if (preset === 'strong') return level === 'low' ? 0.22 : 0.38
  if (preset === 'weak') return 0.12
  return level === 'low' ? 0.16 : 0.28
}

function opacityFor(preset: AmbientPreset): number {
  if (preset === 'strong') return 0.28
  if (preset === 'weak') return 0.12
  return 0.18
}

function randomRange(min: number, max: number) {
  return Math.random() * (max - min) + min
}

function rebuildParticles() {
  const count = densityFor(activeLevel.value, activePreset.value)
  const speed = speedFor(activeLevel.value, activePreset.value)
  particles = Array.from({ length: count }, () => ({
    x: Math.random() * canvasWidth,
    y: Math.random() * canvasHeight,
    vx: randomRange(-speed, speed),
    vy: randomRange(-speed, speed),
    size: randomRange(1, 2.4),
  }))
}

function resizeCanvas() {
  const canvas = canvasRef.value
  if (!canvas) return
  const dpr = window.devicePixelRatio || 1
  canvasWidth = window.innerWidth
  canvasHeight = window.innerHeight
  canvas.width = canvasWidth * dpr
  canvas.height = canvasHeight * dpr
  canvas.style.width = `${canvasWidth}px`
  canvas.style.height = `${canvasHeight}px`
  ctx = canvas.getContext('2d')
  if (ctx) ctx.setTransform(dpr, 0, 0, dpr, 0, 0)
  rebuildParticles()
}

function animate() {
  if (!ctx) {
    animationId = requestAnimationFrame(animate)
    return
  }
  ctx.clearRect(0, 0, canvasWidth, canvasHeight)

  if (particles.length === 0) {
    animationId = requestAnimationFrame(animate)
    return
  }

  ctx.globalAlpha = opacityFor(activePreset.value)
  ctx.fillStyle = '#00e5ff'

  for (const p of particles) {
    p.x += p.vx
    p.y += p.vy
    if (p.x < 0) p.x += canvasWidth
    if (p.x > canvasWidth) p.x -= canvasWidth
    if (p.y < 0) p.y += canvasHeight
    if (p.y > canvasHeight) p.y -= canvasHeight
    ctx.beginPath()
    ctx.arc(p.x, p.y, p.size, 0, Math.PI * 2)
    ctx.fill()
  }

  animationId = requestAnimationFrame(animate)
}

function stop() {
  if (animationId !== null) {
    cancelAnimationFrame(animationId)
    animationId = null
  }
}

onMounted(() => {
  resizeCanvas()
  animationId = requestAnimationFrame(animate)
  window.addEventListener('resize', resizeCanvas)
})

onUnmounted(() => {
  stop()
  window.removeEventListener('resize', resizeCanvas)
  particles = []
})

watch([activeLevel, activePreset], () => {
  rebuildParticles()
})
</script>

<style scoped>
.ambient-canvas {
  position: fixed;
  inset: 0;
  width: 100vw;
  height: 100vh;
  pointer-events: none;
  z-index: 0;
}
</style>
