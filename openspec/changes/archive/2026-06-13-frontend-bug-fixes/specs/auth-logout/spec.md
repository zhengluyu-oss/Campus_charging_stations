## ADDED Requirements

### Requirement: Complete logout cleanup
The system SHALL clear ALL authentication state (token AND user object) when the user logs out.

#### Scenario: Logout from UserDashboard
- **WHEN** user confirms logout in UserDashboard
- **THEN** system SHALL call `userStore.$patch({ token: '', user: undefined })` before navigating to `/user-login`

#### Scenario: Logout from Header
- **WHEN** user clicks logout in Header component
- **THEN** system SHALL clear both token AND user object from store before navigating

### Requirement: Prevent access to login page when authenticated
The system SHALL redirect authenticated users away from login/register pages.

#### Scenario: Authenticated user visits login page
- **WHEN** an authenticated user navigates to `/user-login` or `/user-register`
- **THEN** system SHALL redirect to `/user-dashboard`
