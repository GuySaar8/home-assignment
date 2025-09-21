from flask import Flask, render_template
import os
import logging
from models import db, Visit
from config import Config

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

app = Flask(__name__)
app.config.from_object(Config)
db.init_app(app)

# Get environment from environment variable, default to 'dev' if not set
ENVIRONMENT = os.getenv('ENVIRONMENT', 'dev')

logger.info(f"Flask app starting up in environment: {ENVIRONMENT}")
logger.info(f"Database URI configured: {bool(app.config.get('SQLALCHEMY_DATABASE_URI'))}")

@app.route('/')
def hello_world():
    logger.info("Home page accessed")
    visit_count = 0
    try:
        logger.info("Attempting to record visit to home page")
        # Record the visit
        visit = Visit(page='home', environment=ENVIRONMENT)
        db.session.add(visit)
        db.session.commit()
        logger.info("Visit recorded successfully")

        # Get visit count for this page
        visit_count = Visit.query.filter_by(page='home').count()
        logger.info(f"Retrieved visit count: {visit_count}")
    except Exception as e:
        logger.error(f"Database error in home page: {e}", exc_info=True)
        visit_count = "N/A (DB Error)"

    logger.info("Rendering home page template")
    return render_template('index.html', visit_count=visit_count)

@app.route('/about')
def about():
    logger.info("About page accessed")
    visit_count = 0
    try:
        logger.info("Attempting to record visit to about page")
        # Record the visit
        visit = Visit(page='about', environment=ENVIRONMENT)
        db.session.add(visit)
        db.session.commit()
        logger.info("Visit recorded successfully")

        # Get visit count for this page
        visit_count = Visit.query.filter_by(page='about').count()
        logger.info(f"Retrieved visit count for about page: {visit_count}")
    except Exception as e:
        logger.error(f"Database error in about page: {e}", exc_info=True)
        visit_count = "N/A (DB Error)"

    logger.info("Rendering about page template")
    return render_template('about.html', environment=ENVIRONMENT, visit_count=visit_count)

# Create tables on startup if they don't exist (only if database is configured)
def init_db():
    """Initialize database tables if database is properly configured"""
    logger.info("Starting database initialization")
    try:
        db_uri = app.config.get('SQLALCHEMY_DATABASE_URI')
        logger.info(f"Database URI: {db_uri[:50]}..." if db_uri else "No database URI configured")

        if db_uri and 'None' not in db_uri:
            logger.info("Database URI looks valid, attempting to create tables")
            with app.app_context():
                try:
                    # First test basic connectivity
                    logger.info("Testing database connection...")
                    with db.engine.connect() as connection:
                        logger.info("Database connection established successfully")

                        # Test with simple query
                        logger.info("Executing test query...")
                        result = connection.execute(db.text("SELECT 1 as test"))
                        test_result = result.fetchone()
                        logger.info(f"Test query successful: {test_result}")

                    # Now create tables
                    logger.info("Creating database tables...")
                    db.create_all()
                    logger.info("Database tables created successfully")

                    # Verify tables were created
                    logger.info("Verifying table creation...")
                    with db.engine.connect() as connection:
                        # Check if our Message table exists
                        result = connection.execute(db.text("""
                            SELECT table_name
                            FROM information_schema.tables
                            WHERE table_schema = 'public'
                        """))
                        tables = [row[0] for row in result.fetchall()]
                        logger.info(f"Tables found in database: {tables}")

                except Exception as db_error:
                    logger.error(f"Database operation failed: {db_error}")
                    logger.error(f"Error type: {type(db_error).__name__}")
                    import traceback
                    logger.error(f"Full traceback: {traceback.format_exc()}")
                    raise  # Re-raise to be caught by outer try-except
        else:
            logger.warning("Database URI not configured or contains 'None', skipping table creation")
    except Exception as e:
        logger.error(f"Database initialization failed: {e}", exc_info=True)
        # Don't fail the app startup, just log the error
        pass

# Add a health check endpoint
@app.route('/health')
def health_check():
    logger.info("Health check endpoint accessed")
    return {"status": "healthy", "environment": ENVIRONMENT}, 200

# Add a simple test endpoint
@app.route('/test')
def test():
    logger.info("Test endpoint accessed")
    return f"Hello from Flask! Environment: {ENVIRONMENT}", 200

if __name__ == '__main__':
    logger.info("Starting Flask application in development mode")
    # Only initialize database when running directly
    init_db()
    logger.info("Flask app starting on 0.0.0.0:5000")
    app.run(host='0.0.0.0', port=5000, debug=True)
