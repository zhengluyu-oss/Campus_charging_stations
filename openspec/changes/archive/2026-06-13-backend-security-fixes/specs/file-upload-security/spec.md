## ADDED Requirements

### Requirement: File upload MUST validate file types
The system SHALL only allow uploads of specific whitelisted file types.

#### Scenario: Image upload
- **WHEN** a user uploads an image file
- **THEN** the system SHALL verify the file extension is in the whitelist (jpg, jpeg, png, gif, webp)

#### Scenario: Video upload
- **WHEN** a user uploads a video file
- **THEN** the system SHALL verify the file extension is in the whitelist (mp4, avi, mov, mkv)

#### Scenario: Dangerous file type rejected
- **WHEN** a user attempts to upload a file with extension .jsp, .exe, .html, .php, or other dangerous type
- **THEN** the system SHALL reject the upload with an error message

### Requirement: File upload MUST sanitize filenames
The system SHALL sanitize filenames to prevent path traversal attacks.

#### Scenario: Filename with path traversal
- **WHEN** a file is uploaded with filename `../../../etc/passwd.jpg`
- **THEN** the system SHALL extract only the base filename and extension, discarding any path components

#### Scenario: Filename with no extension
- **WHEN** a file is uploaded without an extension
- **THEN** the system SHALL reject the upload or assign a default extension based on MIME type

### Requirement: Reasonable upload size limits
The system SHALL enforce reasonable file size limits.

#### Scenario: Image upload size
- **WHEN** a user uploads an image
- **THEN** the maximum size SHALL be 10MB

#### Scenario: Video upload size
- **WHEN** a user uploads a video
- **THEN** the maximum size SHALL be 100MB
