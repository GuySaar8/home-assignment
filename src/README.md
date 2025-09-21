# Hello World Flask Application

This is a full-featured web application built with Python Flask and PostgreSQL database integration for a DevOps home assignment.

## Application Features

- **Database Integration**: PostgreSQL with SQLAlchemy ORM
- **Visit Tracking**: Persistent visitor counter stored in database
- **Environment Awareness**: Different behavior and styling for dev/prd environments
- **Health Check Endpoints**: `/health` and `/test` for monitoring and debugging
- **Responsive Design**: Clean, modern UI with environment-specific visual indicators
- **Error Handling**: Graceful fallback to SQLite when database is unavailable
- **Comprehensive Logging**: Detailed logging for debugging and monitoring

## Application Structure

```
src/
├── app.py              # Main Flask application
├── models.py           # SQLAlchemy database models
├── config.py           # Configuration and database setup
├── requirements.txt    # Python dependencies
├── requirements-dev.txt # Development dependencies
├── templates/          # Jinja2 HTML templates
│   ├── base.html       # Base template with navigation
│   ├── index.html      # Home page template
│   └── about.html      # About page template
├── static/             # Static assets (CSS, images)
│   ├── css/style.css   # Application styles
│   └── image/comet.png # Application logo
├── tests/              # Test suite
│   └── test_app.py     # Application tests
└── Dockerfile          # Container configuration
```

## Database Models

### Visit Model
- Tracks page visits with timestamps
- Stores visitor information
- Provides visit counting functionality

## API Endpoints

- **`GET /`** - Home page with visit counter
- **`GET /about`** - About page with application information
- **`GET /health`** - Health check endpoint (returns application status)
- **`GET /test`** - Database connectivity test endpoint

## Environment Configuration

The application supports multiple environments through environment variables:

### Required Environment Variables

```bash
# Database Configuration (for PostgreSQL)
DB_HOST=your-rds-endpoint.amazonaws.com
DB_USER=hello_world_user
DB_PASSWORD=your-secure-password
DB_NAME=hello_world
DB_PORT=5432

# Application Environment
ENVIRONMENT=dev|prd|local
```

### Database Fallback
- **Primary**: PostgreSQL (production/development)
- **Fallback**: SQLite in-memory (when PostgreSQL unavailable)

## Local Development

### Prerequisites
- Python 3.11+
- PostgreSQL database (or use SQLite fallback)
- pip package manager

### Step 1: Install Dependencies
```bash
pip install -r requirements.txt
```

### Step 2: Set Environment Variables
Create a `.env` file or export variables:

#### Option A: Create .env file (Recommended for local development)
```bash
# Create .env file in the src/ directory
cat > .env << EOF
DB_HOST=your-database-host
DB_USER=hello_world_user
DB_PASSWORD=your-password
DB_NAME=hello_world
DB_PORT=5432
ENVIRONMENT=local
EOF
```

> **Note**: The `.env` file should be in the same directory as `app.py` (the `src/` folder). Make sure `.env` is included in your `.gitignore` file to avoid committing secrets to version control.

#### Option B: Export environment variables (Alternative)
```bash
export DB_HOST=$(kubectl get secret hello-world-db-secret -n dev -o jsonpath='{.data.DB_HOST}' | base64 -d) \
DB_USER=$(kubectl get secret hello-world-db-secret -n dev -o jsonpath='{.data.DB_USER}' | base64 -d) \
DB_PASSWORD=$(kubectl get secret hello-world-db-secret -n dev -o jsonpath='{.data.DB_PASSWORD}' | base64 -d) \
DB_NAME=$(kubectl get secret hello-world-db-secret -n dev -o jsonpath='{.data.DB_NAME}' | base64 -d) \
DB_PORT=$(kubectl get secret hello-world-db-secret -n dev -o jsonpath='{.data.DB_PORT}' | base64 -d) \
ENVIRONMENT="local"
```

### Step 3: Run the Application
```bash
python app.py
```

The application will be available at: [http://localhost:5000](http://localhost:5000)

## Docker Development

### Build the Image
```bash
docker build -t hello-world-app .
```

### Run with Environment Variables
```bash
docker run -p 5000:5000 \
  -e DB_HOST="your-database-host" \
  -e DB_USER="hello_world_user" \
  -e DB_PASSWORD="your-password" \
  -e DB_NAME="hello_world" \
  -e DB_PORT="5432" \
  -e ENVIRONMENT="local" \
  hello-world-app
```

### Run with SQLite (No Database Required)
```bash
docker run -p 5000:5000 -e ENVIRONMENT="local" hello-world-app
```

## Testing

### Run Tests
```bash
# Install test dependencies
pip install -r requirements-dev.txt

# Run tests
python -m pytest tests/ -v

# Run with coverage
python -m pytest tests/ --cov=. --cov-report=html
```

### Test Coverage
- Application routes testing
- Database model functionality
- Error handling scenarios
- Environment configuration

## Production Features

### Logging
- Comprehensive logging with configurable levels
- Request tracking and database operation logging
- Error logging with stack traces
- Performance monitoring capabilities

### Health Monitoring
- `/health` endpoint for load balancer health checks
- `/test` endpoint for database connectivity verification
- Graceful error handling and recovery
