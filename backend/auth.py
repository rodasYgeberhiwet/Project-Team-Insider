# Basic authentication and user management for Flask
import os
from flask import Blueprint, request, jsonify, current_app
from werkzeug.security import generate_password_hash, check_password_hash
from itsdangerous import TimedJSONWebSignatureSerializer as Serializer, BadSignature, SignatureExpired
from db import db, User

auth_bp = Blueprint('auth', __name__)

def get_serializer():
	secret = current_app.config.get('SECRET_KEY', 'dev_secret')
	return Serializer(secret, expires_in=3600)

# User registration
@auth_bp.route('/register', methods=['POST'])
def register():
	data = request.get_json()
	name = data.get('name')
	password = data.get('password')
	if not name or not password:
		return jsonify({'success': False, 'error': 'Name and password required'}), 400
	if User.query.filter_by(name=name).first():
		return jsonify({'success': False, 'error': 'User already exists'}), 409
	user = User(name=name)
	user.pfp = data.get('pfp', 'default_icon.png')
	user.anonymous = False
	user.password_hash = generate_password_hash(password)
	db.session.add(user)
	db.session.commit()
	return jsonify({'success': True, 'user_id': user.id})

# User login
@auth_bp.route('/login', methods=['POST'])
def login():
	data = request.get_json()
	name = data.get('name')
	password = data.get('password')
	user = User.query.filter_by(name=name).first()
	if not user or not hasattr(user, 'password_hash') or not check_password_hash(user.password_hash, password):
		return jsonify({'success': False, 'error': 'Invalid credentials'}), 401
	s = get_serializer()
	token = s.dumps({'user_id': user.id}).decode('utf-8')
	return jsonify({'success': True, 'token': token})

# Token verification utility
def verify_auth_token(token):
	s = get_serializer()
	try:
		data = s.loads(token)
	except SignatureExpired:
		return None  # Token expired
	except BadSignature:
		return None  # Invalid token
	user = User.query.get(data['user_id'])
	return user

