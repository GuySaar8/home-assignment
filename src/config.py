import os

class Config:
    """Base configuration class"""
    # Database connection settings from environment variables
    DB_USER = os.getenv('DB_USER', 'hello_world_user')
    DB_PASSWORD = os.getenv('DB_PASSWORD')
    DB_HOST = os.getenv('DB_HOST')
    DB_PORT = os.getenv('DB_PORT', '5432')
    DB_NAME = os.getenv('DB_NAME', 'hello_world')

    # Construct database URL
    SQLALCHEMY_DATABASE_URI = (
        f'postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}'
    )
    
    # Disable tracking modifications
    SQLALCHEMY_TRACK_MODIFICATIONS = False