from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.sql import func

db = SQLAlchemy()

# this is an association table for many-to-many relationship between Team and Tag
team_tag = db.Table(
"team_tag",
    db.Column("team_id", db.Integer, db.ForeignKey("team.id"), primary_key=True),
    db.Column("tag_id", db.Integer, db.ForeignKey("tag.id"), primary_key=True)
)

class Review(db.Model):
    """
    Review Model
    Many-to-one relationship with Team and User models
    """
    __tablename__ = "review"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    star_rating = db.Column(db.Float, nullable=True)
    likes = db.Column(db.Integer, nullable=True, default=0)
    date_posted = db.Column(db.DateTime, nullable=False, server_default=func.now())
    time_commitment = db.Column(db.String, nullable=False)

    #---------------change this------------------------
    list_of_pros = db.Column(db.JSON, nullable=True)
    list_of_cons = db.Column(db.JSON, nullable=True)
    team_id = db.Column(db.Integer, db.ForeignKey("team.id"), nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey("user.id"), nullable=True)

    team = db.relationship("Team", back_populates="reviews")
    user = db.relationship("User", back_populates="reviews")

    def __init__(self, **kwargs):
        """
        Initialize Review object
        """
        self.star_rating = kwargs.get("star_rating")
        self.likes = kwargs.get("likes", 0)
        self.time_commitment = kwargs.get("time_commitment")
        self.list_of_pros = kwargs.get("list_of_pros", [])
        self.list_of_cons = kwargs.get("list_of_cons", [])
        self.team_id = kwargs.get("team_id")
        self.user_id = kwargs.get("user_id")

    def serialize(self):
        """
        Serialize Review object
        """
        team_info = None
        if self.team:
            team_info = {
                "id": self.team.id,
                "name": self.team.name
            }

        user_info = None
        if self.user:
            if self.user.anonymous:
                user_info = {
                    "id": self.user.id,
                    "anonymous": True
                }
            else:
                user_info = {
                    "id": self.user.id,
                    "name": self.user.name
                }

        return {
            "id": self.id,
            "star_rating": self.star_rating,
            "likes": self.likes,
            "date_posted": self.date_posted.isoformat() if self.date_posted else None,
            "time_commitment": self.time_commitment,
            "list_of_pros": self.list_of_pros,
            "list_of_cons": self.list_of_cons,
            "team": team_info,
            "user": user_info
        }


class Interview(db.Model):
    """
    Interview Model
    Many-to-one relationship with Team and User models
    """
    __tablename__ = "interview"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    difficulty_rating = db.Column(db.Float, nullable=False)
    date_posted = db.Column(db.DateTime, nullable=False, server_default=func.now())
    experience_desc = db.Column(db.Text, nullable=False)
    tips = db.Column(db.Text, nullable=True)
    team_id = db.Column(db.Integer, db.ForeignKey("team.id"), nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey("user.id"), nullable=False)

    #add the interview difficulty level
    difficulty_level = db.Column(db.Float, nullable=True)

    accepted = db.Column(db.Boolean, nullable=False)

    team = db.relationship("Team", back_populates="interviews")
    user = db.relationship("User", back_populates="interviews")

    def __init__(self, **kwargs):
        """
        Initialize Interview object
        """
        self.difficulty_rating = kwargs.get("difficulty_rating")
        self.experience_desc = kwargs.get("experience_desc")
        self.tips = kwargs.get("tips")
        self.team_id = kwargs.get("team_id")
        self.user_id = kwargs.get("user_id")
        self.accepted = kwargs.get("accepted")

    def serialize(self):
        """
        Serialize Interview object
        """
        team_info = None
        if self.team:
            team_info = {
                "id": self.team.id,
                "name": self.team.name
            }

        user_info = None
        if self.user:
            if self.user.anonymous:
                user_info = {
                    "id": self.user.id,
                    "anonymous": True
                }
            else:
                user_info = {
                    "id": self.user.id,
                    "name": self.user.name
                }

        return {
            "id": self.id,
            "difficulty_rating": self.difficulty_rating,
            "date_posted": self.date_posted.isoformat() if self.date_posted else None,
            "experience_desc": self.experience_desc,
            "tips": self.tips,
            "team": team_info,
            "user": user_info,
            "accepted": self.accepted
        }


class User(db.Model):
    """
    User Model
    One-to-many relationship with Review and Interview models
    No direct relationship with Team - associated_teams stored as JSON list of team names
    """
    __tablename__ = "user"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String, nullable=True)
    grad_year = db.Column(db.Integer, nullable=True)
    anonymous = db.Column(db.Boolean, nullable=False, default=False)

    reviews = db.relationship("Review", back_populates="user", cascade="delete")
    interviews = db.relationship("Interview", back_populates="user", cascade="delete")

    def __init__(self, **kwargs):
        """
        Initialize User object
        """
        self.anonymous = kwargs.get("anonymous", False)

        if self.anonymous:
            self.name = None
        else:
            self.name = kwargs.get("name")

        self.grad_year = kwargs.get("grad_year")

    def serialize(self):
        """
        Serialize User object
        """
        if self.anonymous:
            return {
                "id": self.id,
                "anonymous": True,
                "grad_year": self.grad_year,
            }
        else:
            return {
                "id": self.id,
                "name": self.name,
                "grad_year": self.grad_year,
                "anonymous": False,
            }


class Team(db.Model):
    """
    Team Model
    One-to-many relationship with Review and Interview models
    No relationship with User - teams don't track members
    """
    __tablename__ = "team"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String, nullable=False)
    description = db.Column(db.Text, nullable=False)
    comp = db.Column(db.String, nullable=True)
    hours = db.Column(db.String, nullable=True)
    #add the interview difficulty level
    
    tags = db.relationship("Tag", secondary = "team_tag", backref = "team")  #??-------

    reviews = db.relationship("Review", back_populates="team", cascade="delete")
    interviews = db.relationship("Interview", back_populates="team", cascade="delete")


    def __init__(self, **kwargs):
        """
        Initialize Team object
        """
        self.name = kwargs.get("name")
        self.description = kwargs.get("description")
        self.tags = []
        self.comp = kwargs.get("comp")
        self.hours = kwargs.get("hours")
        

    # Helper method to compute stats
    def _compute_stats(self):
        num_reviews = len(self.reviews)

        if num_reviews == 0:
            return {
                "review_count": 0,
                "avg_star_rating": None
            }

        avg_star = sum(r.star_rating for r in self.reviews) / num_reviews

        return {
            "review_count": num_reviews,
            "avg_star_rating": avg_star
        }


    def serialize(self):
        """
        Serialize Team object
        """
        return {
            "id": self.id,
            "name": self.name,
            "description": self.description,
            "tags": [t.serialize() for t in self.tags],
            "reviews": [review.serialize() for review in self.reviews],
            "reviews_count": len(self.reviews),
            "interviews_count": len(self.interviews),
            "interviews": [interview.serialize() for interview in self.interviews],
        
            
        }


class Tag(db.Model):
    """
    a model to represent tags associated with teams
    """
    __tablename__ = 'tag'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String, nullable=False)
    def __init__(self, **kwargs):
        """
        Initialize Tag object
        """
        self.name = kwargs.get("name")
    def serialize(self):
        """
        Serialize Tag object
        """
        return {
            "id": self.id,
            "name": self.name
        }


