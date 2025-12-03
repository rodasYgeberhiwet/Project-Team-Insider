from flask import Flask, request, jsonify
from flask_cors import CORS
from datetime import datetime
from moderation import moderate_text  # AI moderation function
from config import Config
from auth import auth_bp
from db import db, User, Team, Review, Interview



app = Flask(__name__)
CORS(app)
app.config.from_object(Config)
app.register_blueprint(auth_bp)

# --- MVP DB initialization ---
db.init_app(app)
with app.app_context():
    db.create_all()

app = Flask(__name__)
CORS(app)

app = Flask(__name__)
CORS(app)

# Temporary in-memory storage
tags = []

team_id_counter = 1
review_id_counter = 1
interview_id_counter = 1
tag_id_counter = 1


#  TEAMS --------

# Get all teams
@app.route("/teams", methods=["GET"])
def get_teams():
    teams = Team.query.all()
    return jsonify({"success": True, "data": teams})

# Create new team
@app.route("/teams", methods=["POST"])
def create_team():
    data = request.get_json()

    team = Team(
        name=data.get("name"),
        description=data.get("description")
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
def get_reviews_for_team(team_id):
    team = Team.query.get(team_id)
    if not team:
        return jsonify({"success": False, "error": "Team not found"}), 404

    reviews = Review.query.filter_by(team_id=team_id).all()
    return jsonify({"success": True, "data": [r.serialize() for r in reviews]})



# Create review with moderation
@app.route("/teams/<int:team_id>/reviews", methods=["POST"])
def create_review(team_id):
    global review_id_counter
    data = request.get_json()

    full_text = " ".join(data.get("list_of_pros", [])) + " " + " ".join(data.get("list_of_cons", []))
    moderation_result = moderate_text(full_text)

    if moderation_result["decision"] == "REJECT":
        return jsonify({
            "success": False,
            "error": "Review rejected",
            "moderation": moderation_result
        }), 403

    new_review = {
        "id": review_id_counter,
        "team_id": team_id,
        "star_rating": data.get("star_rating"),
        "likes": 0,
        "time_commitment": data.get("time_commitment"),
        "list_of_pros": data.get("list_of_pros"),
        "list_of_cons": data.get("list_of_cons"),
        "moderation": moderation_result,
        "date_posted": datetime.utcnow().isoformat()
    }

    db.session.add(new_review)
    db.session.commit()

    return jsonify({"success": True, "data": new_review.serialize()}), 201


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

    review.likes = max(0, review.likes - 1)
    db.session.commit()


    return jsonify({"success": True, "data": review.serialize()})


# Delete review
@app.route("/reviews/<int:review_id>", methods=["DELETE"])
def delete_review(review_id):

    review = Review.query.get(review_id)
    if not review:
        return jsonify({"success": False, "error": "Review not found"}), 404

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

    interview = {
        "id": interview_id_counter,
        "team_id": team_id,
        "difficulty_rating": data.get("difficulty_rating"),
        "experience_desc": data.get("experience_desc"),
        "tips": data.get("tips"),
        "accepted": data.get("accepted"),
        "date_posted": datetime.utcnow().isoformat()
    }

    db.session.add(interview)
    db.session.commit()

    return jsonify({"success": True, "data": interview.serialize()}), 201




# Get all tags
@app.route("/tags", methods=["GET"])
def get_tags():
    return jsonify({"success": True, "data": tags})

# Create new tag
@app.route("/tags", methods=["POST"])
def create_tag():
    global tag_id_counter
    data = request.get_json()

    new_tag = {"id": tag_id_counter, "name": data.get("name")}
    tags.append(new_tag)
    tag_id_counter += 1

    return jsonify({"success": True, "data": new_tag}), 201

# Assign tag to team
@app.route("/teams/<int:team_id>/tags", methods=["POST"])
def assign_tag(team_id):
    data = request.get_json()
    tag_id = data.get("tag_id")

    for team in teams:
        if team["id"] == team_id:
            team["tags"].append(tag_id)
            return jsonify({"success": True, "data": team})

    return jsonify({"success": False, "error": "Team not found"}), 404




if __name__ == "__main__":
    app.run(debug=True)
