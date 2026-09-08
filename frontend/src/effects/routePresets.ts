export type AmbientPreset = 'none' | 'weak' | 'medium' | 'strong'

/** Route → ambient intensity for user frontend */
export function ambientPresetForUserPath(path: string): AmbientPreset {
  if (
    path.startsWith('/welcome') ||
    path === '/' ||
    path.startsWith('/user-login') ||
    path.startsWith('/user-register')
  ) {
    return 'strong'
  }
  if (
    path.startsWith('/user/charging-stations') ||
    path.startsWith('/user/use-charger') ||
    path.startsWith('/charging/')
  ) {
    return 'strong'
  }
  if (
    path.startsWith('/booking') ||
    path.startsWith('/history') ||
    path.startsWith('/user-dashboard') ||
    path.startsWith('/user/charging-service')
  ) {
    return 'medium'
  }
  if (path.startsWith('/profile') || path.startsWith('/news')) {
    return 'weak'
  }
  return 'medium'
}

/** Route → ambient intensity for admin frontend */
export function ambientPresetForAdminPath(path: string): AmbientPreset {
  if (path.startsWith('/login') || path.startsWith('/dashboard')) return 'medium'
  if (
    path.startsWith('/stations') ||
    path.startsWith('/orders') ||
    path.startsWith('/payments') ||
    path.startsWith('/reservations')
  ) {
    return 'weak'
  }
  return 'none'
}
