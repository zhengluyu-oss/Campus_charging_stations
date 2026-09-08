## ADDED Requirements

### Requirement: Command-center dashboard
The admin dashboard MUST be implemented as L3 command-center: KPI emphasis, staggered module entrance (when motion allowed), weak ambient preset, and multiple energy-themed visualizations (trends, utilization, status distribution as data allows).

#### Scenario: Dashboard first paint impact
- **WHEN** an admin opens the dashboard under `full` effects
- **THEN** primary KPIs and at least two chart modules render with the energy theme and L3 motion/ambient treatment

### Requirement: Management pages tiering
Charging station, order, payment, and reservation management views MUST be at least L2 (themed containers, light viz where useful). User, news, and system settings views MUST be L1 (theme + micro-interactions, decoration subordinate to data).

#### Scenario: Orders remain operable
- **WHEN** an admin filters and opens order details
- **THEN** table/list operations remain fully usable and visual effects do not obscure filters, rows, or actions

### Requirement: Projection readability
Admin tables and critical form labels MUST maintain sufficient contrast and font size for projector/demo viewing; decorative glow MUST NOT reduce text contrast below readable levels.

#### Scenario: Table text contrast
- **WHEN** the orders or users table is shown on the dark energy background
- **THEN** primary cell text uses high-contrast text tokens and is readable without hovering

### Requirement: Data over decoration
On admin pages, data density and operability MUST take priority over ambient intensity; ambient strength on admin non-dashboard routes MUST be lower than user L3 flagship pages.

#### Scenario: Lower ambient on admin CRUD
- **WHEN** an admin navigates from dashboard to a CRUD management page
- **THEN** ambient intensity decreases relative to the dashboard preset
