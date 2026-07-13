<template>
  <canvas ref="canvasRef" class="ambient-canvas"></canvas>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'

interface Particle {
  x: number
  y: number
  vx: number
  vy: number
  size: number
}

const PARTICLE_COUNT = 100
const BASE_OPACITY = 0.2
const COLOR = '#00b4d8'
const SPEED_RANGE = 0.3
const SIZE_MIN = 1
const SIZE_MAX = 2.5

const canvasRef = ref<HTMLCanvasElement | null>(null)
let particles: Particle[] = []
let animationId: number | null = null
let canvasWidth = 0
let canvasHeight = 0

function randomRange(min: number, max: number): number {
  return Math.random() * (max - min) + min
}

function initParticles(width: number, height: number): Particle[] {
  return Array.from({ length: PARTICLE_COUNT }, () => ({
    x: Math.random() * width,
    y: Math.random() * height,
    vx: randomRange(-SPEED_RANGE, SPEED_RANGE),
    vy: randomRange(-SPEED_RANGE, SPEED_RANGE),
    size: randomRange(SIZE_MIN, SIZE_MAX)
  }))
}

function resizeCanvas(): void {
  const canvas = canvasRef.value
  if (!canvas) return

  const dpr = window.devicePixelRatio || 1
  canvasWidth = window.innerWidth
  canvasHeight = window.innerHeight

  canvas.width = canvasWidth * dpr
  canvas.height = canvasHeight * dpr
  canvas.style.width = `${canvasWidth}px`
  canvas.style.height = `${canvasHeight}px`

  const ctx = canvas.getContext('2d')
  if (ctx) {
    ctx.scale(dpr, dpr)
  }

  // 粒子数量保持不变，但位置重新适配新尺寸
  if (particles.length === 0) {
    particles = initParticles(canvasWidth, canvasHeight)
  }
}

function animate(): void {
  const canvas = canvasRef.value
  if (!canvas) return

  const ctx = canvas.getContext('2d')
  if (!ctx) return

  ctx.clearRect(0, 0, canvasWidth, canvasHeight)
  ctx.globalAlpha = BASE_OPACITY
  ctx.fillStyle = COLOR

  for (const p of particles) {
    // 更新位置
    p.x += p.vx
    p.y += p.vy

    // 边界环绕
    if (p.x < 0) p.x += canvasWidth
    if (p.x > canvasWidth) p.x -= canvasWidth
    if (p.y < 0) p.y += canvasHeight
    if (p.y > canvasHeight) p.y -= canvasHeight

    // 绘制粒子
    ctx.beginPath()
    ctx.arc(p.x, p.y, p.size, 0, Math.PI * 2)
    ctx.fill()
  }

  animationId = requestAnimationFrame(animate)
}

onMounted(() => {
  resizeCanvas()
  animationId = requestAnimationFrame(animate)
  window.addEventListener('resize', resizeCanvas)
})

onUnmounted(() => {
  if (animationId !== null) {
    cancelAnimationFrame(animationId)
    animationId = null
  }
  window.removeEventListener('resize', resizeCanvas)
  particles = []
})
</script>

<style scoped>
.ambient-canvas {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  pointer-events: none;
  z-index: 0;
}
</style>
