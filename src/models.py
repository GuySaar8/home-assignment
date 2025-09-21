from datetime import datetime
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class Visit(db.Model):
    """Model for tracking page visits"""
    __tablename__ = 'visits'

    id = db.Column(db.Integer, primary_key=True)
    page = db.Column(db.String(50), nullable=False)  # Which page was visited
    timestamp = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)
    environment = db.Column(db.String(20), nullable=False)  # dev/prod environment
