from flask import Flask, request, jsonify
from flask_cors import CORS
from datetime import datetime
import models
from moderation import moderate_text  # AI moderation function

app = Flask(__name__)
CORS(app)

# db = models.DatabaseDriver()
# Temporary in-memory storage
teams = []
reviews = []
interviews = []
tags = []

team_id_counter = 1
review_id_counter = 1
interview_id_counter = 1
tag_id_counter = 1


# -------- TEAMS --------

# Get all teams
@app.route("/teams", methods=["GET"])
def get_teams():
    return jsonify({"success": True, "data": teams})

# Create new team
@app.route("/teams", methods=["POST"])
def create_team():
    global team_id_counter
    data = request.get_json()

    new_team = {
        "id": team_id_counter,
        "name": data.get("name"),
        "description": data.get("description"),
        "tags": []
    }

    teams.append(new_team)
    team_id_counter += 1

    return jsonify({"success": True, "data": new_team}), 201

# Get single team
@app.route("/teams/<int:team_id>", methods=["GET"])
def get_team(team_id):
    team = next((t for t in teams if t["id"] == team_id), None)
    if not team:
        return jsonify({"success": False, "error": "Team not found"}), 404
    return jsonify({"success": True, "data": team})


# -------- REVIEWS --------

# Get all reviews for a team
@app.route("/teams/<int:team_id>/reviews", methods=["GET"])
def get_reviews_for_team(team_id):
    team_reviews = [r for r in reviews if r["team_id"] == team_id]
    return jsonify({"success": True, "data": team_reviews})

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

    reviews.append(new_review)
    review_id_counter += 1

    return jsonify({"success": True, "data": new_review}), 201

# Get all reviews (global)
@app.route("/reviews", methods=["GET"])
def get_all_reviews():
    return jsonify({"success": True, "data": reviews})

# Like a review
@app.route("/reviews/<int:review_id>/like", methods=["POST"])
def like_review(review_id):
    review = None
    for r in reviews:
        if r["id"] == review_id:
            review = r
            break

    if review is None:
        return jsonify({"success": False, "error": "Review not found"}), 404

    review["likes"] += 1

    return jsonify({"success": True, "data": review})

# Unlike a review
@app.route("/reviews/<int:review_id>/unlike", methods=["POST"])
def unlike_review(review_id):
    review = None
    for r in review:
        if r['id']== review_id:
            review = r
            break
    if not review:
        return jsonify({"success": False, "error": "Review not found"}), 404
    
    review["likes"] = max(0, review["likes"] - 1)
    return jsonify({"success": True, "data": review})

# Delete review
@app.route("/reviews/<int:review_id>", methods=["DELETE"])
def delete_review(review_id):
    global reviews
    reviews = [r for r in reviews if r["id"] != review_id]
    return jsonify({"success": True, "message": "Review deleted"})


# -------- INTERVIEWS --------

# Get interview experiences for team
@app.route("/teams/<int:team_id>/interviews", methods=["GET"])
def get_interviews(team_id):
    team_interviews = [i for i in interviews if i["team_id"] == team_id]
    return jsonify({"success": True, "data": team_interviews})

# Create interview entry
@app.route("/teams/<int:team_id>/interviews", methods=["POST"])
def create_interview(team_id):
    global interview_id_counter
    data = request.get_json()

    new_interview = {
        "id": interview_id_counter,
        "team_id": team_id,
        "difficulty_rating": data.get("difficulty_rating"),
        "experience_desc": data.get("experience_desc"),
        "tips": data.get("tips"),
        "accepted": data.get("accepted"),
        "date_posted": datetime.utcnow().isoformat()
    }

    interviews.append(new_interview)
    interview_id_counter += 1

    return jsonify({"success": True, "data": new_interview}), 201


# -------- TAGS --------

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
