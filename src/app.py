from flask import Flask, render_template
import os
from models import db, Visit
from config import Config

app = Flask(__name__)
app.config.from_object(Config)
db.init_app(app)

# Get environment from environment variable, default to 'dev' if not set
ENVIRONMENT = os.getenv('ENVIRONMENT', 'dev')

@app.route('/')
def hello_world():
    # Record the visit
    visit = Visit(page='home', environment=ENVIRONMENT)
    db.session.add(visit)
    db.session.commit()
    
    # Get visit count for this page
    visit_count = Visit.query.filter_by(page='home').count()
    return render_template('index.html', visit_count=visit_count)

@app.route('/about')
def about():
    # Record the visit
    visit = Visit(page='about', environment=ENVIRONMENT)
    db.session.add(visit)
    db.session.commit()
    
    # Get visit count for this page
    visit_count = Visit.query.filter_by(page='about').count()
    return render_template('about.html', environment=ENVIRONMENT, visit_count=visit_count)

# Create tables on startup if they don't exist
@app.before_first_request
def create_tables():
    db.create_all()

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
