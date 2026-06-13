## ADDED Requirements

### Requirement: Unified API directory
All API service files SHALL be located in a single `frontend/src/api/` directory.

#### Scenario: API file location
- **WHEN** a developer needs to find an API service file
- **THEN** all API files SHALL be in `frontend/src/api/` directory

### Requirement: Consistent import paths
All imports of API modules SHALL use the `@/api/` prefix.

#### Scenario: Import API module
- **WHEN** any component imports an API function
- **THEN** the import path SHALL use `@/api/` prefix (e.g., `import { userLogin } from '@/api/user'`)
