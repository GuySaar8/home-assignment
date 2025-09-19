# Use official Python 3.9 image as base
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy requirements and install dependencies
COPY src/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY src/ ./

# Expose port 5000
EXPOSE 5000

# Run the Flask app
CMD ["python", "app.py"]
