import os
import logging

# Configure logging for config module
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class Config:
    """Base configuration class"""
    DB_USER = os.getenv('DB_USER')
    DB_PASSWORD = os.getenv('DB_PASSWORD')
    DB_HOST = os.getenv('DB_HOST')
    DB_PORT = os.getenv('DB_PORT')
    DB_NAME = os.getenv('DB_NAME')

    logger.info(f"Database config - User: {DB_USER}")
    logger.info(f"Database config - Host: {DB_HOST}")
    logger.info(f"Database config - Port: {DB_PORT}")
    logger.info(f"Database config - Name: {DB_NAME}")
    logger.info(f"Database config - Password configured: {bool(DB_PASSWORD)}")

    # Construct database URL - use SQLite for testing if PostgreSQL not configured
    if DB_HOST and DB_PASSWORD:
        SQLALCHEMY_DATABASE_URI = (
            f'postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}'
        )
        logger.info("Using PostgreSQL database")
        logger.info(f"Database URI configured (password masked): postgresql://{DB_USER}:***@{DB_HOST}:{DB_PORT}/{DB_NAME}")
    else:
        # Fallback to SQLite for testing/development
        SQLALCHEMY_DATABASE_URI = 'sqlite:///:memory:'
        logger.info("Using SQLite in-memory database (fallback)")
        logger.info(f"Database URI: {SQLALCHEMY_DATABASE_URI}")

    # Disable tracking modifications
    SQLALCHEMY_TRACK_MODIFICATIONS = False
