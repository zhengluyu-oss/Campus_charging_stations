import { computed, inject, provide, ref, type InjectionKey, type Ref } from 'vue'

export type EffectsLevel = 'off' | 'low' | 'full'
export type AmbientPreset = 'none' | 'weak' | 'medium' | 'strong'

const STORAGE_KEY = 'campus-energy-effects-level'

export interface EffectsContext {
  level: Ref<EffectsLevel>
  setLevel: (level: EffectsLevel) => void
  motionEnabled: Ref<boolean>
  ambientEnabled: Ref<boolean>
  ambientPreset: Ref<AmbientPreset>
  setAmbientPreset: (preset: AmbientPreset) => void
}

export const EFFECTS_KEY: InjectionKey<EffectsContext> = Symbol('campus-energy-effects')

function detectDefaultLevel(): EffectsLevel {
  if (typeof window === 'undefined') return 'full'
  if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return 'off'
  const nav = navigator as Navigator & { deviceMemory?: number }
  const weak =
    (typeof nav.deviceMemory === 'number' && nav.deviceMemory <= 4) ||
    /Android|iPhone|iPad|Mobile/i.test(navigator.userAgent)
  return weak ? 'low' : 'full'
}

function readStoredLevel(): EffectsLevel | null {
  try {
    const raw = localStorage.getItem(STORAGE_KEY)
    if (raw === 'off' || raw === 'low' || raw === 'full') return raw
  } catch {
    /* ignore */
  }
  return null
}

export function createEffectsContext(): EffectsContext {
  const level = ref<EffectsLevel>(readStoredLevel() ?? detectDefaultLevel())
  const ambientPreset = ref<AmbientPreset>('medium')

  const setLevel = (next: EffectsLevel) => {
    level.value = next
    try {
      localStorage.setItem(STORAGE_KEY, next)
    } catch {
      /* ignore */
    }
  }

  const setAmbientPreset = (preset: AmbientPreset) => {
    ambientPreset.value = preset
  }

  const motionEnabled = computed(() => level.value !== 'off')
  const ambientEnabled = computed(() => level.value !== 'off')

  return {
    level,
    setLevel,
    motionEnabled: motionEnabled as unknown as Ref<boolean>,
    ambientEnabled: ambientEnabled as unknown as Ref<boolean>,
    ambientPreset,
    setAmbientPreset,
  }
}

export function provideEffects(): EffectsContext {
  const ctx = createEffectsContext()
  provide(EFFECTS_KEY, ctx)
  return ctx
}

export function useEffects(): EffectsContext {
  const ctx = inject(EFFECTS_KEY)
  if (!ctx) {
    throw new Error('useEffects() requires provideEffects() in a parent component')
  }
  return ctx
}

export function useEffectsOptional(): EffectsContext | null {
  return inject(EFFECTS_KEY, null)
}
