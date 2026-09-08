## ADDED Requirements

### Requirement: Global energy design tokens
The user and admin frontends MUST load a shared Campus Energy token set (CSS custom properties) covering void background, panel glass, brand cyan/volt/amber/fault, text tiers, and grid lines.

#### Scenario: Tokens available at app boot
- **WHEN** either frontend application starts
- **THEN** the documented energy CSS variables are defined on a root-level stylesheet and usable by page and component styles

### Requirement: Typography roles
The system MUST use a display typeface for hero titles and key metrics, and a highly readable body typeface for forms, tables, and paragraphs. Default system UI stacks MUST NOT be the primary brand typefaces.

#### Scenario: Hero and metric typography
- **WHEN** a L3 page renders a hero title or primary metric (e.g. SOC%, kW)
- **THEN** those elements use the display typeface token while surrounding body copy uses the body typeface token

### Requirement: Glass panel primitive
The system MUST provide a reusable glass/panel surface style (low blur, subtle border, restrained highlight) for primary content containers on immersive pages.

#### Scenario: Panel readability
- **WHEN** content is placed inside a glass panel over the void background
- **THEN** primary text remains readable at normal desktop zoom without relying on heavy multi-layer drop shadows

### Requirement: Cross-app visual alignment
User frontend and admin frontend MUST use the same token names and semantic color meanings (cyan interactive, volt charging/success, amber warning, fault error).

#### Scenario: Semantic color consistency
- **WHEN** a charging-in-progress state and a success state are shown on either app
- **THEN** both use the volt semantic token rather than unrelated ad-hoc colors
