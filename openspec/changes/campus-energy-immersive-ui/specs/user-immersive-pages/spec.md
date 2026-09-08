## ADDED Requirements

### Requirement: Page immersion tiers on user app
User frontend pages MUST be classified and implemented at immersion tiers L3, L2, or L1 as follows: welcome/login landing, map/find-station, and charging monitor at L3; reservation, order/payment, and mall/marketing at L2; profile/settings/forms at L1.

#### Scenario: Charging monitor is flagship
- **WHEN** the user opens the charging monitor during an active session under `full` effects
- **THEN** the page presents L3 treatment including cinematic metric emphasis, ambient intensity preset, and live power visualization

### Requirement: Demo critical path completeness
The demo path welcome → map → reserve/start charging → charging monitor → order/payment MUST be fully themed and immersion-complete before non-critical L1 polish blocks release of P0.

#### Scenario: P0 demo path ready
- **WHEN** P0 implementation is marked complete
- **THEN** each step of the demo path uses Campus Energy theme and the prescribed tier behaviors for that step

### Requirement: Map energy visualization
The map/find-station experience MUST include energy-styled markers/panels and an availability or heat-style visualization when data is available.

#### Scenario: Available stations highlighted
- **WHEN** nearby stations are loaded on the map
- **THEN** available versus unavailable stations are visually distinguishable using energy semantic colors

### Requirement: L1 restraint
Profile, settings, and dense forms MUST remain L1: token skin and micro-interactions only, without WebGL ambient density used on L3.

#### Scenario: Settings stays readable
- **WHEN** the user opens settings or profile edit forms
- **THEN** the UI remains readable with minimal decoration and does not mount a heavy L3 ambient preset
