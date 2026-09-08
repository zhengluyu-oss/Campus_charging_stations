## ADDED Requirements

### Requirement: Effects level control
The system MUST support an effects level of `off`, `low`, or `full`, persisted in `localStorage`, and applied globally to ambient visuals and non-essential motion.

#### Scenario: User overrides effects level
- **WHEN** the user selects effects level `off` in settings
- **THEN** ambient canvas rendering stops or remains dormant and non-essential animations do not run

### Requirement: Automatic degradation
On startup the system MUST detect reduced-motion preference and SHOULD detect weak/mobile conditions to choose a default effects level unless the user has a stored override.

#### Scenario: Prefers reduced motion
- **WHEN** the OS/browser reports `prefers-reduced-motion: reduce`
- **THEN** the default effects level is not `full` and cinematic motion is minimized or disabled

### Requirement: Singleton ambient layer
Ambient particle/energy visuals MUST be provided by a single app-root ambient layer that adjusts intensity by route preset, and MUST NOT create a new WebGL/Canvas engine per routed page.

#### Scenario: Route change reuses ambient layer
- **WHEN** the user navigates from a L3 page to another page
- **THEN** the ambient layer remains the same instance (or equivalent singleton) and only its intensity/preset changes

### Requirement: No uncontrolled gesture stack
The immersive UI MUST NOT require MediaPipe/camera hand tracking for core presentation. Any legacy gesture particle integration MUST be removed or fully disabled by default.

#### Scenario: Demo without camera
- **WHEN** camera permission is denied or unavailable
- **THEN** the immersive UI still renders with theme, motion (per level), and visualizations without requiring hand tracking
