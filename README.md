# Cup of Teams

AI-Moderated Reviews for Cornell Project Teams

Cup of Teams is a full-stack platform that allows Cornell students to explore student-run project teams through anonymous, structured peer reviews. The system uses the Google Gemini API to automatically moderate content and filter hate speech or harassment before reviews are published.

---

## What Makes This Project Unique

### AI-Powered Content Moderation (Google Gemini)
All user-submitted reviews are analyzed using the Gemini API before being stored in the database.

- Automatically detects hate speech, harassment, and toxic language  
- Rejects unsafe reviews in real time  
- Supports anonymous posting without compromising safety  
- No manual moderation required  

This allows open discussion while maintaining a respectful platform.

---

### Popularity-Based Team Ranking
Teams are dynamically sorted by real engagement.

- Ranking is based on number of reviews  
- Automatically updates as new reviews are added  
- Avoids hardcoded or biased rankings  

---

### Anonymous but Structured Reviews
Users can post without accounts while still submitting high-quality feedback.

Each review supports:
- Star rating
- Difficulty rating
- Time commitment
- Written experience
- Interview insights

---

### Tag-Driven Discovery
Project teams can be associated with multiple tags such as:
- iOS Development
- Machine Learning
- Robotics
- Biomedical Engineering
- Social Impact

This enables filtering, discovery, and future recommendations.

---

## Tech Stack

Backend:
- Flask (Python)
- SQLAlchemy ORM
- SQLite / PostgreSQL compatible
- Google Gemini API for content moderation

Frontend:
- Swift (UIKit)
- UICollectionView-based UI

Infrastructure:
- Dockerized backend
- REST API architecture

---

## High-Level Architecture

- Swift iOS app communicates with Flask REST API  
- Reviews are sent to Gemini for moderation before insertion  
- Approved content is stored in a relational database  
- Teams aggregate reviews, interviews, and tags dynamically  
- Sorting and filtering are computed server-side  

---

