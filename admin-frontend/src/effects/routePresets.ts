export type AmbientPreset = 'none' | 'weak' | 'medium' | 'strong'

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
