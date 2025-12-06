# Cornell Project Teams Review API

A Flask-based REST API for managing reviews and interview experiences for Cornell University project teams. This application allows students to share their experiences, rate teams, and provide insights into the application/interview process.

## Table of Contents
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Database Schema](#database-schema)
- [API Routes](#api-routes)
- [Setup Instructions](#setup-instructions)
- [Configuration](#configuration)
- [Usage Examples](#usage-examples)

## Features

- **Team Management**: Browse and search through 40+ Cornell project teams
- **Review System**: Share experiences with star ratings, time commitment details, and written feedback
- **Interview Insights**: Post interview experiences including difficulty ratings and tips
- **Tag-Based Filtering**: Filter teams by technical skills and focus areas
- **Content Moderation**: Automatic review moderation to maintain quality
- **Anonymous Posting**: Option to post reviews anonymously
- **Like System**: Upvote helpful reviews

## Tech Stack

- **Backend Framework**: Flask
- **Database**: SQLAlchemy ORM (SQLite/PostgreSQL compatible)
- **CORS**: Flask-CORS for cross-origin requests
- **Content Moderation**: Custom moderation module
- **Python Version**: 3.7+

## Database Schema

### Entity Relationship Diagram
```
User ----< Review >---- Team
  |                       |
  |                       |
  └----< Interview >------┘
                          |
                          |
                    Tag >----- (Many-to-Many via team_tag)
```

### Models

#### **User**
Represents a student who writes reviews or shares interview experiences.

| Field | Type | Description |
|-------|------|-------------|
| `id` | Integer | Primary key (auto-increment) |
| `name` | String | User's name (nullable if anonymous) |
| `grad_year` | Integer | Expected graduation year |
| `major` | String | Student's major (nullable) |
| `anonymous` | Boolean | Whether to hide user identity (default: False) |

**Relationships:**
- One-to-Many with `Review` (cascade delete)
- One-to-Many with `Interview` (cascade delete)

---

#### **Team**
Represents a Cornell project team or organization.

| Field | Type | Description |
|-------|------|-------------|
| `id` | Integer | Primary key (auto-increment) |
| `name` | String | Team name (required) |
| `description` | Text | Team description and mission |
| `comp` | String | Competition level (Open/Moderate/Competitive) |
| `hours` | String | Expected weekly time commitment (e.g., "15-20") |

**Relationships:**
- One-to-Many with `Review` (cascade delete)
- One-to-Many with `Interview` (cascade delete)
- Many-to-Many with `Tag` (via `team_tag` association table)

---

#### **Review**
Student reviews of their experience with a team.

| Field | Type | Description |
|-------|------|-------------|
| `id` | Integer | Primary key (auto-increment) |
| `star_rating` | Float | Rating out of 5 stars (nullable) |
| `likes` | Integer | Number of upvotes (default: 0) |
| `date_posted` | DateTime | Timestamp of creation (auto-generated) |
| `time_commitment` | String | Actual time commitment experienced |
| `review` | JSON | Detailed review content |
| `team_id` | Integer | Foreign key to Team (required) |
| `user_id` | Integer | Foreign key to User (nullable) |

**Relationships:**
- Many-to-One with `Team`
- Many-to-One with `User`

---

#### **Interview**
Interview/application experiences shared by students.

| Field | Type | Description |
|-------|------|-------------|
| `id` | Integer | Primary key (auto-increment) |
| `difficulty_rating` | Float | Interview difficulty rating (required) |
| `difficulty_level` | Float | Processed difficulty level (nullable) |
| `date_posted` | DateTime | Timestamp of creation (auto-generated) |
| `experience_desc` | Text | Description of interview experience (required) |
| `tips` | Text | Tips for future applicants (nullable) |
| `accepted` | Boolean | Whether the user was accepted (required) |
| `team_id` | Integer | Foreign key to Team (required) |
| `user_id` | Integer | Foreign key to User (required) |

**Relationships:**
- Many-to-One with `Team`
- Many-to-One with `User`

---

#### **Tag**
Technical skills and focus areas associated with teams.

| Field | Type | Description |
|-------|------|-------------|
| `id` | Integer | Primary key (auto-increment) |
| `name` | String | Tag name (e.g., "Machine Learning", "iOS Development") |

**Relationships:**
- Many-to-Many with `Team` (via `team_tag` association table)

---

### Association Table: `team_tag`
Junction table for the many-to-many relationship between Teams and Tags.

| Field | Type | Description |
|-------|------|-------------|
| `team_id` | Integer | Foreign key to Team (primary key) |
| `tag_id` | Integer | Foreign key to Tag (primary key) |

## API Routes

### Teams

#### `GET /teams`
Get all teams, sorted by review count (descending).

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "Cornell AppDev",
      "description": "Student-run team building mobile apps...",
      "tags": [
        {"id": 1, "name": "iOS Development"},
        {"id": 2, "name": "Android Development"}
      ],
      "reviews": [...],
      "reviews_count": 15,
      "interviews": [...],
      "interviews_count": 8
    }
  ]
}
```

---

#### `POST /teams`
Create a new team.

**Request Body:**
```json
{
  "name": "New Project Team",
  "description": "Team description here",
  "comp": "Moderate",
  "hours": "10-15"
}
```

**Response:** `201 Created`
```json
{
  "success": true,
  "data": {
    "id": 42,
    "name": "New Project Team",
    ...
  }
}
```

---

#### `GET /teams/<team_id>`
Get detailed information about a specific team.

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "Cornell AppDev",
    "description": "...",
    "tags": [...],
    "reviews": [...],
    "interviews": [...]
  }
}
```

**Error Response:** `404 Not Found`
```json
{
  "success": false,
  "error": "Team not found"
}
```

---

### Reviews

#### `GET /teams/<team_id>/reviews`
Get all reviews for a specific team.

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "star_rating": 4.5,
      "likes": 12,
      "date_posted": "2024-11-15T10:30:00",
      "time_commitment": "15-20 hours/week",
      "review": {"content": "Great experience..."},
      "team": {
        "id": 1,
        "name": "Cornell AppDev"
      },
      "user": {
        "id": 5,
        "name": "Jane Doe"
      }
    }
  ]
}
```

---

#### `POST /teams/<team_id>/reviews`
Create a new review with automatic content moderation.

**Request Body:**
```json
{
  "name": "John Smith",
  "grad_year": 2026,
  "major": "Computer Science",
  "anonymous": false,
  "star_rating": 4.5,
  "time_commitment": "15-20 hours/week",
  "review": "This team was amazing! I learned so much about iOS development..."
}
```

**Success Response:** `201 Created`
```json
{
  "success": true,
  "data": {
    "id": 42,
    "star_rating": 4.5,
    "likes": 0,
    ...
  }
}
```

**Moderation Rejection:** `403 Forbidden`
```json
{
  "success": false,
  "error": "Review rejected",
  "moderation": {
    "decision": "REJECT",
    "reason": "..."
  }
}
```

**Validation Error:** `400 Bad Request`
```json
{
  "success": false,
  "error": "name is required for a review"
}
```

---

#### `GET /reviews`
Get all reviews across all teams.

**Response:**
```json
{
  "success": true,
  "data": [...]
}
```

---

#### `POST /reviews/<review_id>/like`
Increment the like count for a review.

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "likes": 13,
    ...
  }
}
```

---

#### `POST /reviews/<review_id>/unlike`
Decrement the like count (only allowed for review author).

**Request Body:**
```json
{
  "user_id": 5
}
```

**Success Response:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "likes": 12,
    ...
  }
}
```

**Authorization Error:** `403 Forbidden`
```json
{
  "success": false,
  "error": "You cannot unlike a review you did not write"
}
```

---

#### `DELETE /reviews/<review_id>`
Delete a review (only allowed for review author).

**Request Body:**
```json
{
  "user_id": 5
}
```

**Success Response:**
```json
{
  "success": true,
  "message": "Review deleted"
}
```

**Authorization Error:** `403 Forbidden`
```json
{
  "success": false,
  "error": "You cannot delete another user's review"
}
```

---

### Interviews

#### `GET /teams/<team_id>/interviews`
Get all interview experiences for a specific team.

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "difficulty_rating": 3.5,
      "date_posted": "2024-11-10T14:20:00",
      "experience_desc": "The interview had 3 rounds...",
      "tips": "Practice coding problems and know your resume well",
      "accepted": true,
      "team": {
        "id": 1,
        "name": "Cornell AppDev"
      },
      "user": {
        "id": 7,
        "name": "Alice Johnson"
      }
    }
  ]
}
```

---

#### `POST /teams/<team_id>/interviews`
Create a new interview experience entry.

**Request Body:**
```json
{
  "user_id": 7,
  "difficulty_rating": 3.5,
  "experience_desc": "The interview process consisted of...",
  "tips": "Make sure to prepare behavioral questions",
  "accepted": true
}
```

**Success Response:** `201 Created`
```json
{
  "success": true,
  "data": {
    "id": 10,
    "difficulty_rating": 3.5,
    ...
  }
}
```

**Validation Error:** `400 Bad Request`
```json
{
  "success": false,
  "error": "user_id is required"
}
```

---

### Tags

#### `GET /tags`
Get all available tags.

**Response:**
```json
{
  "success": true,
  "data": [
    {"id": 1, "name": "iOS Development"},
    {"id": 2, "name": "Machine Learning"},
    {"id": 3, "name": "Robotics"}
  ]
}
```

---

#### `POST /tags`
Create a new tag (returns existing tag if name already exists).

**Request Body:**
```json
{
  "name": "Blockchain"
}
```

**Success Response:** `201 Created` or `200 OK`
```json
{
  "success": true,
  "data": {
    "id": 25,
    "name": "Blockchain"
  }
}
```

**Validation Error:** `400 Bad Request`
```json
{
  "success": false,
  "error": "Tag name required"
}
```

---

#### `POST /teams/<team_id>/tags`
Assign a tag to a team.

**Request Body:**
```json
{
  "tag_id": 5
}
```

**Response:** `200 OK`
```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "Cornell AppDev",
    "tags": [
      {"id": 1, "name": "iOS Development"},
      {"id": 5, "name": "UI/UX Design"}
    ],
    ...
  }
}
```

---

#### `GET /tags/<tag_name>/teams`
Get all teams associated with a specific tag, sorted by review count.

**Example:** `GET /tags/Machine%20Learning/teams`

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 2,
      "name": "Cornell Data Science",
      "description": "...",
      "tags": [...],
      "reviews_count": 20
    }
  ]
}
```

**Error Response:** `404 Not Found`
```json
{
  "success": false,
  "error": "Tag not found"
}
```

---

## Setup Instructions

### Prerequisites
- Python 3.7 or higher
- pip package manager

### Installation

1. **Clone the repository**
```bash
git clone 
cd cornell-teams-api
```

2. **Create a virtual environment**
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

3. **Install dependencies**
```bash
pip install flask flask-cors flask-sqlalchemy
```

4. **Set up configuration**
Create a `config.py` file with your database configuration:
```python
class Config:
    SQLALCHEMY_DATABASE_URI = 'sqlite:///teams.db'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SECRET_KEY = 'your-secret-key-here'
```

5. **Create moderation module**
Create a `moderation.py` file with content moderation logic:
```python
def moderate_text(text):
    # Implement your moderation logic
    return {
        "decision": "APPROVE",  # or "REJECT"
        "reason": None
    }
```

6. **Initialize the database**
```bash
python app.py
```

The database will be automatically created with 40+ pre-populated Cornell project teams on first run.

### Running the Application
```bash
python app.py
```

The API will be available at `http://localhost:5000`

---

## Configuration

### Database Configuration
Modify `config.py` to change database settings:
```python
class Config:
    # Use PostgreSQL in production
    SQLALCHEMY_DATABASE_URI = 'postgresql://user:password@localhost/dbname'
    
    # Or SQLite for development
    SQLALCHEMY_DATABASE_URI = 'sqlite:///teams.db'
    
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SECRET_KEY = 'your-secret-key-here'
```

### CORS Configuration
CORS is currently enabled for all origins. For production, restrict origins in `app.py`:
```python
CORS(app, resources={r"/*": {"origins": "https://yourfrontend.com"}})
```

---

## Usage Examples

### Example 1: Get All Teams with Reviews
```bash
curl http://localhost:5000/teams
```

### Example 2: Create a Review
```bash
curl -X POST http://localhost:5000/teams/1/reviews \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "grad_year": 2026,
    "major": "Computer Science",
    "anonymous": false,
    "star_rating": 4.5,
    "time_commitment": "15-20 hours/week",
    "review": "Great learning experience!"
  }'
```

### Example 3: Filter Teams by Tag
```bash
curl http://localhost:5000/tags/Machine%20Learning/teams
```

### Example 4: Add Interview Experience
```bash
curl -X POST http://localhost:5000/teams/1/interviews \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 5,
    "difficulty_rating": 3.0,
    "experience_desc": "Two technical rounds plus behavioral",
    "tips": "Review data structures thoroughly",
    "accepted": true
  }'
```

### Example 5: Like a Review
```bash
curl -X POST http://localhost:5000/reviews/1/like
```

---

## Pre-populated Teams

The application initializes with 40+ Cornell project teams including:

**Technical/Development:**
- Cornell AppDev (iOS, Android, Backend)
- Cornell Data Science (ML, Analytics)
- Cornell Digital Tech & Innovation (Product, Web, Design)
- Hack4Impact Cornell (Social Impact Development)

**Robotics/Hardware:**
- Cornell Mars Rover
- Cornell Autonomous Underwater Vehicle
- Cornell University Unmanned Air Systems
- Combat Robotics @ Cornell

**Engineering Competitions:**
- Cornell FSAE Racing
- Cornell Rocketry
- Cornell Design Build Fly
- Cornell Electric Vehicles

**Social Impact:**
- Engineers Without Borders
- Cornell Engineering World Health
- AguaClara Cornell

And many more! Each team includes descriptions, competition levels, time commitments, and relevant tags.

---

## Database Relationships Explained

### User ↔ Review (One-to-Many)
- One user can write multiple reviews
- Each review belongs to one user
- Reviews cascade delete when user is deleted
- Anonymous users have `name` set to `None`

### User ↔ Interview (One-to-Many)
- One user can share multiple interview experiences
- Each interview belongs to one user
- Interviews cascade delete when user is deleted

### Team ↔ Review (One-to-Many)
- One team can have multiple reviews
- Each review is about one team
- Reviews cascade delete when team is deleted

### Team ↔ Interview (One-to-Many)
- One team can have multiple interview experiences
- Each interview is about one team
- Interviews cascade delete when team is deleted

### Team ↔ Tag (Many-to-Many)
- One team can have multiple tags
- One tag can be associated with multiple teams
- Managed through `team_tag` association table
- Example: "Cornell AppDev" has tags: iOS Development, Android Development, Backend Development

---

## Error Handling

All endpoints return consistent error responses:
```json
{
  "success": false,
  "error": "Error message here"
}
```

Common HTTP status codes:
- `200 OK` - Successful GET/POST request
- `201 Created` - Successful resource creation
- `400 Bad Request` - Missing required fields
- `403 Forbidden` - Authorization failure or content moderation rejection
- `404 Not Found` - Resource not found

---

## Content Moderation

Reviews are automatically moderated using the `moderate_text()` function from `moderation.py`. Reviews that fail moderation return:
```json
{
  "success": false,
  "error": "Review rejected",
  "moderation": {
    "decision": "REJECT",
    "reason": "Inappropriate content detected"
  }
}
```

---

## Future Enhancements

- [ ] User authentication and JWT tokens
- [ ] Rate limiting for API endpoints
- [ ] Advanced search and filtering
- [ ] Email notifications for new reviews
- [ ] Admin dashboard for content management
- [ ] Photo uploads for teams
- [ ] Comment threads on reviews
- [ ] Recommendation algorithm based on tags and interests

---

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

**Built with ❤️ for the Cornell community**
