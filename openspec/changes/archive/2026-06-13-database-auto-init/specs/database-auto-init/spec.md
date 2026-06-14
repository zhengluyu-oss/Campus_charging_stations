## ADDED Requirements

### Requirement: Database tables auto-created on startup
The system SHALL automatically create all required database tables when the application starts.

#### Scenario: Fresh database
- **WHEN** the application starts with an empty database `campus_charging_station`
- **THEN** all 8 tables SHALL be created automatically (users, admin, charging_stations, orders, payments, reservations, news, system_logs)

#### Scenario: Database already exists
- **WHEN** the application starts and tables already exist
- **THEN** no error SHALL occur (scripts use `CREATE TABLE IF NOT EXISTS`)

### Requirement: Initial data seeded
The system SHALL insert default admin account and sample charging stations on first run.

#### Scenario: First startup
- **WHEN** the application starts for the first time
- **THEN** a default admin account (admin/admin123456) and sample charging stations SHALL be inserted

#### Scenario: Restart with existing data
- **WHEN** the application restarts and data already exists
- **THEN** no duplicate data SHALL be inserted (scripts use `INSERT IGNORE`)

### Requirement: SQL scripts located in common module
The SQL scripts SHALL be in `backend/common/src/main/resources/` so both admin and user modules can use them.

#### Script location
- Schema: `backend/common/src/main/resources/schema.sql`
- Data: `backend/common/src/main/resources/data.sql`
