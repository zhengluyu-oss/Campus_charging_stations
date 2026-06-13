/// <reference types="vite/client" />

declare module '*.vue' {
  import type { DefineComponent } from 'vue'
  const component: DefineComponent<{}, {}, any>
  export default component
}

// MediaPipe packages are Closure-compiled IIFEs that attach to the global
// scope. Their bundled .d.ts declares ES exports, but the .js files do not
// actually export anything -- they set window.Hands / window.Camera instead.
// We re-declare the modules here so TypeScript is satisfied, and the runtime
// code accesses the constructors via the globalThis / window object.

declare module '@mediapipe/hands' {
  export interface NormalizedLandmark {
    x: number
    y: number
    z: number
    visibility?: number
  }

  export type NormalizedLandmarkList = NormalizedLandmark[]
  export type NormalizedLandmarkListList = NormalizedLandmarkList[]
  export type InputImage = HTMLVideoElement | HTMLImageElement | HTMLCanvasElement

  export interface InputMap {
    image: InputImage
  }

  export interface Results {
    multiHandLandmarks: NormalizedLandmarkListList
    multiHandWorldLandmarks: Array<Array<{ x: number; y: number; z: number }>>
    multiHandedness: Array<{ index: number; score: number; label: string }>
    image: CanvasImageSource
  }

  export interface Options {
    selfieMode?: boolean
    maxNumHands?: number
    modelComplexity?: 0 | 1
    minDetectionConfidence?: number
    minTrackingConfidence?: number
  }

  export type ResultsListener = (results: Results) => Promise<void> | void

  export interface HandsConfig {
    locateFile?: (path: string, prefix?: string) => string
  }

  export class Hands {
    constructor(config?: HandsConfig)
    close(): Promise<void>
    onResults(listener: ResultsListener): void
    initialize(): Promise<void>
    reset(): void
    send(inputs: InputMap): Promise<void>
    setOptions(options: Options): void
  }

  const _default: { Hands: typeof Hands }
  export default _default
}

declare module '@mediapipe/camera_utils' {
  export interface CameraOptions {
    onFrame: () => Promise<void> | null
    facingMode?: 'user' | 'environment'
    width?: number
    height?: number
  }

  export class Camera {
    constructor(video: HTMLVideoElement, options: CameraOptions)
    start(): Promise<void>
    stop(): Promise<void>
  }

  const _default: { Camera: typeof Camera }
  export default _default
}
