# FitGuard Core Backend

FitGuard is an AI-powered sports training and rehabilitation backend built using Node.js, Express, and MongoDB. It utilizes the Grok (xAI) API to safely generate progressive 30-day training challenges and phased return-to-play recovery protocols based on athlete profiles and injury logs history.

---

## Features

1. **Authentication**: JWT token-based auth with automatic refresh token rotation (supporting multi-session invalidation).
2. **Athlete Profile**: Maintains persistent sport, age, height, and weight profiles.
3. **Injury Logs**: Full injury logging with automated muscle group frequency patterns aggregation.
4. **AI Challenges**: Generates 30-day sports challenges using athlete profile and past injuries to safely strengthen weaknesses and avoid active injuries.
5. **AI Recovery**: Creates phased return-to-play protocols tailored to specific injury logs and the user's broader history.
6. **Notifications/Reminders**: Alerts users about challenge nudges, recovery schedules, and logging details.

---

## Tech Stack
- **Node.js + Express**
- **MongoDB + Mongoose**
- **JWT (Access & Refresh Tokens)**
- **bcryptjs** (Password hashing)
- **express-validator** (Request input validation)
- **native fetch** (xAI API integration via HTTP client)

---

## Setup & Running

1. **Clone and Install Dependencies**
   ```bash
   cd fitguard-core
   npm install
   ```

2. **Configure Environment Variables**
   Create a `.env` file from the example:
   ```bash
   cp .env.example .env
   ```
   Modify the variables inside `.env`:
   - `PORT`: Server port (default: 5000)
   - `MONGO_URI`: MongoDB connection string
   - `JWT_SECRET`: Secret key for access tokens
   - `JWT_REFRESH_SECRET`: Secret key for refresh tokens
   - `XAI_API_KEY`: xAI (Grok) developer API key
   - `XAI_BASE_URL`: xAI (Grok) API base URL (default: `https://api.x.ai/v1`)
   - `XAI_MODEL`: xAI (Grok) model choice (default: `grok-2`)
   - `FRONTEND_URL`: Production URL of the frontend (for CORS whitelist)

3. **Start Development Server**
   ```bash
   npm run dev
   ```
   The backend will start at `http://localhost:5000`.

4. **Verify Health Status**
   Send a `GET` request to:
   ```
   http://localhost:5000/health
   ```

---

## API Endpoints List

All responses follow the structured output format:
```json
{
  "success": true,
  "data": {},
  "message": "Descriptive message"
}
```

### 1. Authentication
*Requires no authentication*

* **POST `/api/auth/register`**
  - **Body**:
    ```json
    {
      "name": "John Doe",
      "email": "john@example.com",
      "password": "securepassword",
      "sport": "Basketball",
      "age": 28,
      "weight": 82.5,
      "height": 188.0
    }
    ```
  - **Response**: Access token, refresh token, and sanitized user object.

* **POST `/api/auth/login`**
  - **Body**:
    ```json
    {
      "email": "john@example.com",
      "password": "securepassword"
    }
    ```
  - **Response**: Access token, refresh token, and user details.

* **POST `/api/auth/logout`**
  - **Body**:
    ```json
    {
      "refreshToken": "your_refresh_token_string"
    }
    ```
  - **Response**: Revokes the refresh token.

* **POST `/api/auth/refresh-token`**
  - **Body**:
    ```json
    {
      "refreshToken": "your_refresh_token_string"
    }
    ```
  - **Response**: Rotated access and refresh tokens.

---

### 2. User Profile
*Requires JWT Authorization Bearer header*

* **GET `/api/user/profile`**
  - **Response**: Returns current user profile details.

* **PUT `/api/user/profile`**
  - **Body** (all fields optional):
    ```json
    {
      "name": "John Doe Jr",
      "sport": "Soccer",
      "age": 29,
      "weight": 81.0,
      "height": 188.0
    }
    ```
  - **Response**: Updated profile object.

---

### 3. Injury Logs
*Requires JWT Authorization Bearer header*

* **POST `/api/injuries`**
  - **Body**:
    ```json
    {
      "muscleGroup": "left hamstring",
      "injuryType": "strain",
      "severity": "moderate",
      "dateOccurred": "2026-05-15T00:00:00.000Z",
      "recoveryStatus": "active",
      "notes": "Felt pop while sprinting."
    }
    ```
  - **Response**: Created injury log object and creates a notification reminder.

* **GET `/api/injuries`**
  - **Response**: Array of all injury logs for the logged-in user.

* **GET `/api/injuries/patterns`**
  - **Response**: Aggregated array indicating frequency of injury per muscle group (e.g. `[ { "muscleGroup": "left hamstring", "count": 3 } ]`).

* **GET `/api/injuries/:id`**
  - **Response**: Single injury log detail matching ID.

* **PUT `/api/injuries/:id`**
  - **Body** (fields optional):
    ```json
    {
      "recoveryStatus": "recovered"
    }
    ```
  - **Response**: Updated injury log. Automatically creates a congratulatory recovery reminder if status is changed to `recovered`.

* **DELETE `/api/injuries/:id`**
  - **Response**: Deletes log.

---

### 4. Challenges
*Requires JWT Authorization Bearer header*

* **POST `/api/challenges/generate`**
  - **Body**:
    ```json
    {
      "difficulty": "intermediate"
    }
    ```
  - **AI Prompt Action**: Gathers user profile & full injury patterns (active + recurring muscles). Instructs Grok (xAI) to compile a safe 30-day program avoiding active injury zones and targeting weak/recurring injury muscle groups for strengthening.
  - **Response**: Newly created active Challenge schema containing a 30-day task list.

* **GET `/api/challenges`**
  - **Response**: History of all challenges.

* **GET `/api/challenges/active`**
  - **Response**: The current active challenge object (or null).

* **PUT `/api/challenges/:id/day/:dayNumber/complete`**
  - **Response**: Marks day `dayNumber` of challenge `:id` as completed with timestamps. If day 30 is completed, sets challenge status to `completed`. Generates challenge nudges.

* **PUT `/api/challenges/:id/abandon`**
  - **Response**: Updates status to `abandoned`.

---

### 5. Recovery Protocols
*Requires JWT Authorization Bearer header*

* **POST `/api/recovery/generate`**
  - **Body**:
    ```json
    {
      "injuryLogId": "your_active_injury_log_id"
    }
    ```
  - **AI Prompt Action**: Feeds target injury plus overall athlete medical history to Grok (xAI). Generates progressive rehabilitation phases (Phase 1, Phase 2, etc.) loaded with specific clinical recovery routines.
  - **Response**: Created active RecoveryProtocol schema with list of rehabilitation phases.

* **GET `/api/recovery`**
  - **Response**: Array of all recovery protocols.

* **GET `/api/recovery/active`**
  - **Response**: Array of active recovery protocols.

* **PUT `/api/recovery/:id/phase/:phaseNumber/complete`**
  - **Response**: Completes specific phase number. Advances the current phase index. If all phases complete, marks protocol as `completed` and automatically changes the underlying `InjuryLog` status to `recovered`.

---

### 6. Notifications
*Requires JWT Authorization Bearer header*

* **GET `/api/notifications`**
  - **Response**: List of user notifications (sorted newest first).

* **PUT `/api/notifications/:id/read`**
  - **Response**: Marks single notification as read.

* **PUT `/api/notifications/read-all`**
  - **Response**: Marks all notifications as read.

* **DELETE `/api/notifications/:id`**
  - **Response**: Deletes notification log.
