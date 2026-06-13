## ADDED Requirements

### Requirement: Database credentials MUST be externalized
The system SHALL NOT hardcode database credentials in application.yml.

#### Scenario: Application startup
- **WHEN** the application starts
- **THEN** it SHALL read database credentials from environment variables with fallback defaults for development only

### Requirement: Redis credentials MUST be externalized
The system SHALL NOT hardcode Redis credentials in application.yml.

#### Scenario: Redis connection
- **WHEN** the application connects to Redis
- **THEN** it SHALL read the password from an environment variable

### Requirement: JWT secret MUST be externalized
The system SHALL NOT hardcode the JWT signing secret in source code or configuration files.

#### Scenario: JWT token generation
- **WHEN** the application generates or validates a JWT token
- **THEN** it SHALL read the secret from an environment variable

### Requirement: File paths MUST be configurable
The system SHALL NOT hardcode absolute file paths.

#### Scenario: File upload directory
- **WHEN** the application handles file uploads
- **THEN** the base path SHALL be read from configuration with a sensible default

### Requirement: Swagger SHOULD be disabled in production
The system SHALL allow disabling Swagger/API docs via configuration.

#### Scenario: Production deployment
- **WHEN** the application is deployed with `springdoc.api-docs.enabled=false`
- **THEN** the Swagger UI and API docs endpoints SHALL not be accessible
