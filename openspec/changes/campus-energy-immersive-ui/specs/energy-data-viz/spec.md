## ADDED Requirements

### Requirement: Shared chart theme
All immersive charts MUST use a shared dark energy theme mapped from Campus Energy tokens (background, axis, series cyan/volt accents).

#### Scenario: Theme consistency across apps
- **WHEN** a trend chart renders on the user charging page and on the admin dashboard
- **THEN** both charts use the shared energy theme tokens rather than default light chart skins

### Requirement: Reusable chart components
The frontends MUST provide reusable visualization building blocks for at least trend lines, status/donut rings, and heat/occupancy strips used by L2/L3 pages.

#### Scenario: Occupancy strip on reservation
- **WHEN** a reservation time selection UI needs occupancy visualization
- **THEN** it can render via the shared heat/occupancy strip component with energy theme styling

### Requirement: Empty and loading viz states
Charts MUST show intentional empty and loading states consistent with the energy UI, not a blank white box.

#### Scenario: Empty dashboard series
- **WHEN** an admin dashboard chart has no data
- **THEN** the UI shows an energy-styled empty state message/placeholder instead of an unstyled blank chart area

### Requirement: Performance-conscious chart animation
Chart animations MUST respect effects level and reduced motion; under `off` or reduced motion, charts render final frames without decorative animation.

#### Scenario: Charts with effects off
- **WHEN** effects level is `off`
- **THEN** charts display data without entrance/animation flourishes
