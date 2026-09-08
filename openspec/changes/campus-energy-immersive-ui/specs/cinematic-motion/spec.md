## ADDED Requirements

### Requirement: Page enter motion
L2 and L3 pages MUST support a short enter sequence (opacity + small translate, staggered children within about 40–80ms) when effects level allows motion.

#### Scenario: Full effects page enter
- **WHEN** effects level is `full` and a L3 page mounts
- **THEN** primary content blocks animate in with a short staggered entrance rather than appearing with no transition

### Requirement: Route transition restraint
Route transitions MUST complete quickly (target about 200–350ms) using restrained cross-fade or equivalent, and MUST NOT block interaction indefinitely.

#### Scenario: Fast navigation
- **WHEN** the user navigates between two immersive routes under `full` effects
- **THEN** the transition finishes within the restrained duration budget and the destination page becomes interactive

### Requirement: Metric count-up
Key KPI and charging metrics on L3 surfaces MUST support numeric count-up or equivalent emphasis when motion is enabled.

#### Scenario: Dashboard KPI emphasis
- **WHEN** the admin dashboard loads under `full` effects with numeric KPIs
- **THEN** the primary KPI numbers animate to their values instead of only static text

### Requirement: Charging energy progress
The charging monitor view MUST present progress with a unidirectional energy/light treatment (not full-screen flashing), gated by effects level.

#### Scenario: Reduced motion charging progress
- **WHEN** effects level is `off` or reduced motion is active during charging
- **THEN** progress remains clearly visible via static or minimally animated indicators without strobing

### Requirement: Forbidden cheap motion
The system MUST NOT use continuous title glow pulsing, rainbow rotating borders, or full-viewport rainbow gradient sliding as brand motion.

#### Scenario: No strobing brand chrome
- **WHEN** the welcome or dashboard page is idle
- **THEN** titles and card borders do not continuously pulse or spin through rainbow gradients
