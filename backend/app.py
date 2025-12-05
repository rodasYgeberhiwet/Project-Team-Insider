from flask import Flask, request, jsonify
from flask_cors import CORS
from datetime import datetime
from moderation import moderate_text
from config import Config
from db import db, User, Team, Review, Interview, Tag

app = Flask(__name__)
CORS(app)
app.config.from_object(Config)


db.init_app(app)
with app.app_context():
    db.create_all()

    #initializing teams and tags
    if Team.query.count() == 0:

        initial_teams = [
            {
                "name": "Cornell AppDev",
                "description": "Student-run team building mobile apps for the Cornell community. Developers learn iOS, Android, full-stack, and design.",
                "comp": "Competitive",
                "tags": ["iOS Development", "Android Development", "Backend Development"],
                "hours": "15-20"
            },
            {
                "name": "Cornell Data Science",
                "description": "Work on real-world data science projects with industry partners. Focus on ML, analytics, and data visualization.",
                "comp": "Moderate",
                "tags": ["Machine Learning", "Data Analytics"],
                "hours": "8-12"
            },
            {
                "name": "Cornell Digital Tech & Innovation",
                "description": "Create digital products that solve campus problems. Roles include product management, design, and engineering.",
                "comp": "Moderate",
                "tags": ["Product Management", "Web Development", "UI/UX Design"],
                "hours": "10-15"
            },
            {
                "name": "Cornell University Unmanned Air Systems",
                "description": "Design, build, and compete with autonomous UAVs. Work on computer vision, controls, and aerodynamics.",
                "comp": "Competitive",
                "tags": ["Computer Vision", "Autonomous Systems"],
                "hours": "20-25"
            },
            {
                "name": "Cornell Autonomous Underwater Vehicle",
                "description": "Design and build autonomous submarines for international competition. Focus on robotics and marine engineering.",
                "comp": "Competitive",
                "tags": ["Robotics", "Computer Vision", "Embedded Systems"],
                "hours": "15-20"
            },
            {
                "name": "Cornell Baja Racing",
                "description": "Design, build and race off-road vehicles for SAE Collegiate Baja competitions. Hands-on engineering across drivetrain, suspension, frame, and brakes.",
                "comp": "Competitive",
                "tags": ["Mechanical Engineering", "Vehicle Dynamics"],
                "hours": "15-20"
            },

            # ---- YOU DO NOT NEED TO MODIFY ANYTHING BELOW ----
            # copying the entire rest of your list
            {
                "name": "AguaClara Cornell",
                "description": "Develop sustainable drinking water treatment technologies for communities in developing countries using open-source engineering.",
                "comp": "Open",
                "tags": ["Water Treatment", "Civil Engineering"],
                "hours": "8-12"
            },
            {
                "name": "Combat Robotics @ Cornell",
                "description": "Design and build combat robots to compete in heavyweight robot battles. Learn mechanical design, electronics, and strategy.",
                "comp": "Moderate",
                "tags": ["Mechanical Design", "Electronics"],
                "hours": "10-15"
            },
            {
                "name": "Cornell Assistive Technologies",
                "description": "Design and build assistive devices for people with disabilities. Collaborate with clients to create custom solutions.",
                "comp": "Open",
                "tags": ["Mechanical Design", "Human-Centered Design"],
                "hours": "8-12"
            },
            {
                "name": "Cornell Autonomous Sailboat Team",
                "description": "Build autonomous sailing vessels that navigate using AI and computer vision. Compete in international robotics competitions.",
                "comp": "Competitive",
                "tags": ["Autonomous Navigation", "Computer Vision", "Marine Engineering"],
                "hours": "12-18"
            },
            {
                "name": "Cornell University Biomedical Device",
                "description": "Design and prototype medical devices and healthcare technologies. Work on projects from concept to clinical testing.",
                "comp": "Moderate",
                "tags": ["Medical Device Design", "Prototyping"],
                "hours": "10-15"
            },
            {
                "name": "Cornell ChemE Car",
                "description": "Design a shoebox-sized car powered and stopped by chemical reactions. Compete in AIChE regional and national competitions.",
                "comp": "Competitive",
                "tags": ["Chemical Engineering", "Reaction Kinetics"],
                "hours": "12-15"
            },
            {
                "name": "Cornell Concrete Canoe",
                "description": "Design, build, and race a canoe made entirely of concrete. Compete in ASCE National Concrete Canoe Competition.",
                "comp": "Competitive",
                "tags": ["Materials Science", "Structural Design"],
                "hours": "12-18"
            },
            {
                "name": "Cornell Custom Silicon Systems",
                "description": "Design custom integrated circuits and silicon chips. Work on VLSI design, chip fabrication, and hardware verification.",
                "comp": "Competitive",
                "tags": ["VLSI Design", "Digital Logic"],
                "hours": "15-20"
            },
            {
                "name": "Cornell DEBUT",
                "description": "Design innovative biomedical devices for the NIH DEBUT Challenge. Focus on affordable healthcare solutions.",
                "comp": "Moderate",
                "tags": ["Biomedical Engineering"],
                "hours": "10-15"
            },
            {
                "name": "Cornell Design Build Fly",
                "description": "Design, build, and fly remote-controlled aircraft for AIAA DBF competition. Focus on aerodynamics and manufacturing.",
                "comp": "Competitive",
                "tags": ["Aerodynamics", "Aircraft Design"],
                "hours": "15-20"
            },
            {
                "name": "Cornell Electric Vehicles",
                "description": "Convert vehicles to electric powertrains and compete in Formula SAE Electric. Work on battery systems, motors, and controls.",
                "comp": "Competitive",
                "tags": ["Electric Powertrains", "Battery Systems"],
                "hours": "15-20"
            },
            {
                "name": "Cornell Engineering World Health",
                "description": "Repair and maintain medical equipment for hospitals in developing countries. Focus on global health technology.",
                "comp": "Open",
                "tags": ["Medical Equipment", "Global Health"],
                "hours": "8-12"
            },
            {
                "name": "Cornell University Extended Reality",
                "description": "Create immersive VR, AR, and XR experiences. Projects range from games to educational simulations and research tools.",
                "comp": "Open",
                "tags": ["Virtual Reality", "Game Development"],
                "hours": "8-12"
            },
            {
                "name": "Hack4Impact Cornell",
                "description": "Build software solutions for nonprofits and social good organizations. Full-stack development for social impact.",
                "comp": "Moderate",
                "tags": ["Full-Stack Development", "Social Impact"],
                "hours": "10-15"
            },
            {
                "name": "Cornell Hyperloop",
                "description": "Design high-speed pod prototypes for SpaceX Hyperloop competitions. Work on propulsion, levitation, and controls.",
                "comp": "Competitive",
                "tags": ["Propulsion Systems", "Control Systems"],
                "hours": "15-20"
            },
            {
                "name": "Cornell iGEM",
                "description": "Engineer biological systems for the International Genetically Engineered Machine competition. Synthetic biology research and design.",
                "comp": "Competitive",
                "tags": ["Synthetic Biology", "Genetic Engineering"],
                "hours": "15-20"
            },
            {
                "name": "Cornell Mars Rover",
                "description": "Design and build Mars rovers for University Rover Challenge. Autonomous navigation, science tasks, and robotic arm manipulation.",
                "comp": "Competitive",
                "tags": ["Robotics", "Autonomous Systems", "Mechanical Design"],
                "hours": "15-20"
            },
            {
                "name": "Cornell Nexus",
                "description": "Consulting team working with startups and tech companies on product strategy, growth, and operations.",
                "comp": "Competitive",
                "tags": ["Strategy Consulting", "Product Management"],
                "hours": "10-15"
            },
            {
                "name": "Cornell FSAE Racing",
                "description": "Design and build formula-style race cars for Formula SAE competitions. Complete vehicle engineering from chassis to electronics.",
                "comp": "Competitive",
                "tags": ["Automotive Engineering", "Vehicle Dynamics"],
                "hours": "20-25"
            },
            {
                "name": "Cornell Rocketry",
                "description": "Design, build, and launch high-powered rockets for competitions like Spaceport America Cup. Propulsion, avionics, and recovery systems.",
                "comp": "Competitive",
                "tags": ["Rocket Propulsion", "Avionics", "Aerospace Engineering"],
                "hours": "15-20"
            },
            {
                "name": "Cornell Seismic Design",
                "description": "Design earthquake-resistant structures for EERI Seismic Design Competition. Focus on structural engineering and natural disaster resilience.",
                "comp": "Competitive",
                "tags": ["Structural Engineering", "Earthquake Engineering"],
                "hours": "10-15"
            },
            {
                "name": "Cornell Steel Bridge",
                "description": "Design and construct scale-model steel bridges for ASCE National Student Steel Bridge Competition. Structural design and fabrication.",
                "comp": "Competitive",
                "tags": ["Structural Design", "Fabrication"],
                "hours": "12-18"
            },
            {
                "name": "Cornell University Solar Boat",
                "description": "Design solar-powered boats for Solar Splash competition. Work on marine engineering, solar systems, and efficient propulsion.",
                "comp": "Competitive",
                "tags": ["Solar Power", "Marine Engineering"],
                "hours": "12-18"
            },
            {
                "name": "Cornell AutoBoat",
                "description": "Build autonomous surface vessels for RoboNation's RoboBoat competition. Focus on maritime robotics and AI navigation.",
                "comp": "Competitive",
                "tags": ["Autonomous Navigation", "Maritime Robotics"],
                "hours": "12-18"
            },
            {
                "name": "CU Autonomous Drone",
                "description": "Develop autonomous drones for search and rescue, delivery, and other applications. Computer vision, path planning, and controls.",
                "comp": "Moderate",
                "tags": ["Drone Technology", "Path Planning"],
                "hours": "10-15"
            },
            {
                "name": "CU GeoData",
                "description": "Apply geospatial data science and GIS to solve real-world problems. Work with satellite imagery, mapping, and spatial analysis.",
                "comp": "Open",
                "tags": ["GIS", "Spatial Analysis"],
                "hours": "8-12"
            },
            {
                "name": "Engineers for a Sustainable World",
                "description": "Work on sustainability projects addressing energy, water, and environmental challenges. Campus and community-focused initiatives.",
                "comp": "Open",
                "tags": ["Sustainability", "Environmental Engineering"],
                "hours": "6-10"
            },
            {
                "name": "Engineers in Action",
                "description": "Design and build footbridges in rural communities in developing countries. International service learning and structural engineering.",
                "comp": "Open",
                "tags": ["Structural Engineering", "International Development"],
                "hours": "8-12"
            },
            {
                "name": "Engineers Without Borders",
                "description": "Partner with communities worldwide to address basic human needs through engineering projects in water, sanitation, and infrastructure.",
                "comp": "Open",
                "tags": ["Global Development"],
                "hours": "8-12"
            },
            {
                "name": "SensTech Cornell",
                "description": "Develop wearable and sensor technologies for health monitoring, sports performance, and human-computer interaction.",
                "comp": "Moderate",
                "tags": ["Wearable Technology", "Sensor Systems"],
                "hours": "10-15"
            }
        ]

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
    user_id=user.id
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
