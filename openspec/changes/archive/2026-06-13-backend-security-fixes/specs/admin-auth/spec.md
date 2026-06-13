## ADDED Requirements

### Requirement: Admin passwords MUST be BCrypt-hashed
The system SHALL store all admin passwords using BCrypt hashing, never in plain text.

#### Scenario: Admin registration
- **WHEN** a new admin user is created via `add()` method
- **THEN** the password SHALL be encoded with `PasswordEncoder.encode()` before being saved to the database

#### Scenario: Admin login
- **WHEN** an admin attempts to log in
- **THEN** the system SHALL query by username only, then use `PasswordEncoder.matches()` to verify the password against the stored hash

#### Scenario: Plain-text password migration
- **WHEN** an admin logs in with a plain-text password that matches the database
- **THEN** the system SHALL automatically re-hash the password with BCrypt and update the database (same pattern as user login)

### Requirement: Passwords MUST NOT be logged
The system SHALL never log password values in any log level.

#### Scenario: Username already exists check
- **WHEN** `checkAdmin()` detects a duplicate username
- **THEN** the log message SHALL NOT include the password value

### Requirement: Admin LoginInterceptor MUST set UserContext
The admin `LoginInterceptor` SHALL extract JWT claims and set `UserContext` for downstream code.

#### Scenario: Valid admin token
- **WHEN** a request arrives with a valid JWT token
- **THEN** the interceptor SHALL call `UserContext.setUserId()` and `UserContext.setUsername()` from the token claims

#### Scenario: Request completes
- **WHEN** the request processing completes
- **THEN** the interceptor SHALL call `UserContext.clear()` in the `afterCompletion` method

### Requirement: Consistent password requirements
The system SHALL enforce consistent password length rules across admin and user modules.

#### Scenario: Password validation
- **WHEN** any password is validated (login or registration)
- **THEN** the minimum length SHALL be 6 characters and maximum SHALL be 30 characters
