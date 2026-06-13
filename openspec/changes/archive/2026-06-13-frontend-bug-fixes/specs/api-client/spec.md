## ADDED Requirements

### Requirement: Unified API client usage
All API modules SHALL use the centralized `utils/request.ts` axios instance instead of raw `axios`.

#### Scenario: News API uses centralized client
- **WHEN** `apis/news.ts` makes any API call
- **THEN** it SHALL import and use `request` from `@/utils/request` instead of raw `axios`

#### Scenario: Upload API uses centralized client
- **WHEN** `apis/upload.ts` makes any API call
- **THEN** it SHALL import and use `request` from `@/utils/request` instead of raw `axios`

### Requirement: Correct API URL paths
All API URLs SHALL be consistent and avoid double-prefix issues with the Vite proxy.

#### Scenario: stopCharging endpoint
- **WHEN** `stopCharging` is called
- **THEN** the URL SHALL be `/user/charging/start` pattern (no `/user-api` prefix that gets double-rewritten)

#### Scenario: Consistent URL prefix
- **WHEN** any API function constructs a URL
- **THEN** it SHALL NOT include `/user-api` prefix when using the centralized request instance (which already has baseURL configured)

### Requirement: Remove dead code
Unused files, imports, and duplicate definitions SHALL be removed.

#### Scenario: Dead API file removed
- **WHEN** `api/axios.ts` is not imported by any file
- **THEN** it SHALL be deleted

#### Scenario: Dead constants removed
- **WHEN** `constants/chargingStationConstants.ts` is not imported by any file
- **THEN** it SHALL be deleted

#### Scenario: Dead viewmodel removed
- **WHEN** `viewmodel/OrderModel.ts` is not imported by any file
- **THEN** it SHALL be deleted

#### Scenario: Duplicate ChargingStation interface removed
- **WHEN** `api/chargingStationsApi.ts` defines a local `ChargingStation` interface that conflicts with `viewmodel/ChargingStationModel.ts`
- **THEN** the local duplicate SHALL be removed and imports SHALL use the canonical model
