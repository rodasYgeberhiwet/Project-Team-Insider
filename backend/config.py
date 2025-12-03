import os
from dotenv import load_dotenv

load_dotenv()

class Config:
	# Database
	SQLALCHEMY_DATABASE_URI = os.getenv("DATABASE_URL", "sqlite:///dev.db")
	SQLALCHEMY_TRACK_MODIFICATIONS = False


	SECRET_KEY = os.getenv("SECRET_KEY", "dev_secret")

	
	API_KEY = os.getenv("API_KEY")

	# Other config options can be added here
