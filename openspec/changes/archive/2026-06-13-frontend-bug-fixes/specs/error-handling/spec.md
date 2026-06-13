## ADDED Requirements

### Requirement: Unified error handling with session expiry
The system SHALL use a single axios instance (`utils/request.ts`) for all API calls, with interceptors that handle token injection, business errors, and session expiry uniformly.

#### Scenario: Session expired during API call
- **WHEN** any API call returns `state === -1`
- **THEN** system SHALL show a dialog informing the user, clear the store via `$patch`, and redirect to `/user-login`

#### Scenario: Composition API store reset
- **WHEN** session expiry triggers store cleanup
- **THEN** system SHALL use `userStore.$patch({ token: '', user: undefined })` instead of `userStore.$reset()` which is unsupported in Composition API stores

### Requirement: Consistent API error message display
The system SHALL display meaningful error messages from API responses to the user.

#### Scenario: Login failure with server message
- **WHEN** login API returns a business error with `message` field
- **THEN** system SHALL display the server-provided message, not a generic fallback

#### Scenario: Login failure with network error
- **WHEN** login API call fails due to network issue
- **THEN** system SHALL display "网络错误，请稍后重试"
