from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # allow Swift/iOS to call


# PUBLIC ROUTES


@app.route("/teams", methods=["GET"])
def get_all_teams():
    """Return all project teams with basic info."""
    return jsonify({"message": "GET all teams"})


@app.route("/teams/<int:team_id>", methods=["GET"])
def get_team_details(team_id):
    """Return detailed info about a specific team."""
    return jsonify({"message": "GET team details", "team_id": team_id})


@app.route("/tags", methods=["GET"])
def get_all_tags():
    """Return all tags (AI, robotics, consulting, etc.)"""
    return jsonify({"message": "GET all tags"})


@app.route("/teams/<int:team_id>/tags", methods=["GET"])
def get_team_tags(team_id):
    """Return all tags assigned to a specific team."""
    return jsonify({"message": "GET tags for team", "team_id": team_id})


@app.route("/teams/<int:team_id>/reviews", methods=["GET"])
def get_reviews(team_id):
    """Return all reviews for a team."""
    return jsonify({"message": "GET reviews", "team_id": team_id})


# -------------------------------------------------------
# REVIEW CRUD (Create, Read, Update, Delete)
# -------------------------------------------------------

@app.route("/teams/<int:team_id>/reviews", methods=["POST"])
def create_review(team_id):
    """
    Create a new review for a team.
    Data will come from Swift as JSON.
    Example payload:
    { "rating": 5, "difficulty": 3, "hours": 10, "text": "good team" }
    """
    data = request.get_json()
    return jsonify({"message": "POST review received", "team_id": team_id, "data": data}), 201


@app.route("/reviews/<int:review_id>", methods=["PATCH"])
def update_review(review_id):
    """
    Update an existing review.
    Payload might include updated text or numbers.
    """
    data = request.get_json()
    return jsonify({"message": "PATCH update review", "review_id": review_id, "updated": data})


@app.route("/reviews/<int:review_id>", methods=["DELETE"])
def delete_review(review_id):
    """Delete an existing review."""
    return jsonify({"message": "DELETE review", "review_id": review_id})


# TEAM META — HOURS, PROCESS, EVENTS, TAGS
# (ANYONE CAN SET THESE SINCE NO AUTH)

@app.route("/teams/<int:team_id>/hours", methods=["PATCH"])
def update_hours(team_id):
    """
    Update the estimated hours per week for a team.
    Payload example: { "hours_per_week": 8 }
    """
    data = request.get_json()
    return jsonify({"message": "PATCH update hours", "team_id": team_id, "data": data})


@app.route("/teams/<int:team_id>/interview", methods=["PATCH"])
def update_interview(team_id):
    """
    Update interview process description.
    Example payload:
    { "process": "Round 1: Application, Round 2: Technical interview" }
    """
    data = request.get_json()
    return jsonify({"message": "PATCH update interview", "team_id": team_id, "data": data})


@app.route("/teams/<int:team_id>/events", methods=["POST"])
def create_event(team_id):
    """
    Create an event for recruitment (coffee chat, info session).
    Example payload:
    { "name": "info session", "date": "2025-02-15", "location": "Duffield Hall" }
    """
    data = request.get_json()
    return jsonify({"message": "POST event created", "team_id": team_id, "data": data})


@app.route("/teams/<int:team_id>/tags", methods=["POST"])
def add_tag(team_id):
    """Assign a new tag to a team."""
    data = request.get_json()
    return jsonify({"message": "POST add tag", "team_id": team_id, "data": data})


@app.route("/teams/<int:team_id>/tags/<int:tag_id>", methods=["DELETE"])
def remove_tag(team_id, tag_id):
    """Remove tag from team."""
    return jsonify({"message": "DELETE remove tag", "team_id": team_id, "tag_id": tag_id})



# ADMIN-LIKE ROUTES (BUT STILL OPEN)

@app.route("/teams", methods=["POST"])
def create_team():
    """
    Create a new project team.
    Example payload:
    { "name": "Cornell Mars Rover", "website": "...", "description": "..." }
    """
    data = request.get_json()
    return jsonify({"message": "POST create team", "data": data}), 201


@app.route("/reviews/<int:review_id>/moderate", methods=["PATCH"])
def moderate_review(review_id):
    """
    Admin-style moderation for reviews.
    Example payload:
    { "action": "approve" } or { "action": "remove" }
    """
    data = request.get_json()
    return jsonify({"message": "PATCH moderate review", "review_id": review_id, "data": data})




if __name__ == "__main__":
    app.run(debug=True)
