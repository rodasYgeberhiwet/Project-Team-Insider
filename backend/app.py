from flask import Flask, request, jsonify
from flask_cors import CORS
from datetime import datetime
from moderation import moderate_text
from config import Config
from db import db, User, Team, Review, Interview, Tag
from teams import initial_teams

app = Flask(__name__)
CORS(app)
app.config.from_object(Config)

#initialize project teams
db.init_app(app)
with app.app_context():
    db.create_all()

    #initializing teams and tags
    if Team.query.count() == 0:

        initial_teams = initial_teams()

        for t in initial_teams:
            tag_objects = []
            for tag_name in t["tags"]:
                tag = Tag.query.filter_by(name=tag_name).first()
                if not tag:
                    tag = Tag(name=tag_name)
                    db.session.add(tag)
                    db.session.flush()
                tag_objects.append(tag)

            team = Team(
                name=t["name"],
                description=t["description"],
                comp=t["comp"],
                hours=t["hours"]
            )

            team.tags.extend(tag_objects)

            db.session.add(team)

        db.session.commit()



#  TEAMS

# Get all teams
@app.route("/teams", methods=["GET"])
def get_teams():
    teams = Team.query.all()
    sorted_teams = sorted(teams, key=lambda t: len(t.reviews), reverse=True)
    return jsonify({"success": True, "data": [t.serialize() for t in sorted_teams]})

# Create new team
@app.route("/teams", methods=["POST"])
def create_team():
    data = request.get_json()
    
    team = Team(
        name=data.get("name"),
        description=data.get("description"),
        comp = data.get("comp"),
        hours = data.get("hours")
    )
    db.session.add(team)
    db.session.commit()

    return jsonify({"success": True, "data": team.serialize()}), 201


# Get single team
@app.route("/teams/<int:team_id>", methods=["GET"])
def get_team(team_id):
    team = Team.query.get(team_id)
    if not team:
        return jsonify({"success": False, "error": "Team not found"}), 404
    return jsonify({"success": True, "data": team.serialize()})

# REVIEWS 

# Get all reviews for a team
@app.route("/teams/<int:team_id>/reviews", methods=["GET"])
def get_reviews_for_a_team(team_id):
    team = Team.query.get(team_id)
    if not team:
        return jsonify({"success": False, "error": "Team not found"}), 404

    reviews = Review.query.filter_by(team_id=team_id).all()
    return jsonify({"success": True, "data": [r.serialize() for r in reviews]})



# Create review with moderation
@app.route("/teams/<int:team_id>/reviews", methods=["POST"])
def create_review(team_id):
    data = request.get_json()
    required_fields = ["name", "grad_year"]
    for f in required_fields:
        if f not in data:
            return jsonify({"success": False, "error": f"{f} is required for a review"}), 400

    user = User(
    name=data.get("name"),
    grad_year=data.get("grad_year"),
    anonymous=data.get("anonymous", False)
    )
    db.session.add(user)
    db.session.commit()

    moderation_result = moderate_text(data.get("review", ""))

    if moderation_result["decision"] == "REJECT":
        return jsonify({
            "success": False,
            "error": "Review rejected",
            "moderation": moderation_result
        }), 403

    review = Review(
    star_rating=data.get("star_rating"),
    time_commitment=data.get("time_commitment"),
    review=data.get("review"),
    team_id=team_id,
    user_id=user.id,
    major=data.get("major")
    )   


    db.session.add(review)
    db.session.commit()

    return jsonify({"success": True, "data": review.serialize()}), 201


# Get all reviews (global)
@app.route("/reviews", methods=["GET"])
def get_all_reviews():

    reviews = Review.query.all()
    return jsonify({"success": True, "data": [r.serialize() for r in reviews]})


# Like a review
@app.route("/reviews/<int:review_id>/like", methods=["POST"])
def like_review(review_id):
    review = Review.query.get(review_id)
    if not review:
        return jsonify({"success": False, "error": "Review not found"}), 404

    review.likes += 1
    db.session.commit()

    return jsonify({"success": True, "data": review.serialize()})

# Unlike a review
@app.route("/reviews/<int:review_id>/unlike", methods=["POST"])
def unlike_review(review_id):
    review = Review.query.get(review_id)
    if not review:
        return jsonify({"success": False, "error": "Review not found"}), 404

    user_id = request.get_json().get("user_id")
    if review.user_id != user_id:
        return jsonify({"success": False, "error": "You cannot unlike a review you did not write"}), 403

    review.likes = review.likes - 1 if review.likes > 0 else 0
    db.session.commit()


    return jsonify({"success": True, "data": review.serialize()})


# Delete review
@app.route("/reviews/<int:review_id>", methods=["DELETE"])
def delete_review(review_id):

    review = Review.query.get(review_id)
    if not review:
        return jsonify({"success": False, "error": "Review not found"}), 404

    user_id = request.get_json().get("user_id")
    if review.user_id != user_id:
        return jsonify({"success": False, "error": "You cannot delete another user's review"}), 403

    db.session.delete(review)
    db.session.commit()

    return jsonify({"success": True, "message": "Review deleted"})




# Get interview experiences for team
@app.route("/teams/<int:team_id>/interviews", methods=["GET"])
def get_interviews(team_id):

    interviews = Interview.query.filter_by(team_id=team_id).all()
    return jsonify({"success": True, "data": [i.serialize() for i in interviews ]})

# Create interview entry
@app.route("/teams/<int:team_id>/interviews", methods=["POST"])
def create_interview(team_id):
    data = request.get_json()

    team = Team.query.get(team_id)
    if not team:
        return jsonify({"success": False, "error": "Team not found"}), 404

    user_id = data.get("user_id")
    if user_id is None:
        return jsonify({"success": False, "error": "user_id is required"}), 400

    interview = Interview(
        difficulty_rating=data.get("difficulty_rating"),
        experience_desc=data.get("experience_desc"),
        tips=data.get("tips"),
        accepted=data.get("accepted"),
        team_id=team_id,
        user_id=user_id,
    )

    db.session.add(interview)
    db.session.commit()

    return jsonify({"success": True, "data": interview.serialize()}), 201



# Get all tags
@app.route("/tags", methods=["GET"])
def get_tags(): 
    tags = Tag.query.all()
    return jsonify({"success": True, "data": [t.serialize() for t in tags]})

# Create new tag
@app.route("/tags", methods=["POST"])
def create_tag():
    data = request.get_json()
    tag_name = data.get("name")
    if not tag_name:
        return jsonify({"success": False, "error": "Tag name required"}), 400

    existing = Tag.query.filter_by(name=tag_name).first()
    if existing:
        return jsonify({"success": True, "data": existing.serialize()}), 200
    tag = Tag(
        name = data.get("name"),
    )
    db.session.add(tag)
    db.session.commit()
    return jsonify({"success": True, "data": tag.serialize()}), 201

# Assign tag to team
@app.route("/teams/<int:team_id>/tags", methods=["POST"])
def assign_tag(team_id):
    data = request.get_json()
    tag_id = data.get("tag_id")
    teams = Team.query.get(team_id)
    tag = Tag.query.get(tag_id)
    if not teams:
        return jsonify({"success": False, "error": "Team not found"}), 404
    
    if tag not in teams.tags:
        teams.tags.append(tag)
        db.session.commit()
    

    return jsonify({"success": True, "data": teams.serialize()}), 200

# Get teams by tag
@app.route("/tags/<string:tag_name>/teams", methods=["GET"])
def get_teams_by_tag(tag_name):
    tag = Tag.query.filter_by(name=tag_name).first()

    if not tag:
        return jsonify({"success": False, "error": "Tag not found"}), 404

    teams = tag.teams
    sorted_teams = sorted(teams, key=lambda t: len(t.reviews), reverse=True)
    return jsonify({"success": True, "data": [t.serialize() for t in sorted_teams]})


if __name__ == "__main__":
    app.run(debug=True)
