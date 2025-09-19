# Hello World Flask App

This is a minimal "Hello World" web application built with Python and Flask for a job application home assignment (Phase 1).

## What Has Been Done

## Phase 1: Steps

### Step 1: Run Locally (without Docker)

1. **Install Python (3.7+)**
   Ensure you have Python installed on your system.

2. **Install Dependencies**
   Open a terminal in this directory and run:
   ```bash
   pip install -r requirements.txt
   ```

3. **Run the Application**
   Start the Flask app with:
   ```bash
   python app.py
   ```

4. **Access the App**
   Open your browser and go to: [http://localhost:5000](http://localhost:5000)
   You should see: `Hello, World!`

### Step 2: Build and Run with Docker

1. **Build the Docker Image**
   In the project directory, run:
   ```bash
   docker build -t flask-hello-world .
   ```

2. **Run the Docker Container**
   ```bash
   docker run -p 5000:5000 flask-hello-world
   ```

3. **Access the App in Docker**
   Open your browser and go to: [http://localhost:5000](http://localhost:5000)
   You should see: `Hello, World!`

---

This README is specific to the Flask app and is separate from the main repository README.
