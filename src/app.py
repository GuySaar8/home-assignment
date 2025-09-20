from flask import Flask, render_template
import os

app = Flask(__name__)

# Get environment from environment variable, default to 'dev' if not set
ENVIRONMENT = os.getenv('ENVIRONMENT', 'dev')

@app.route('/')
def hello_world():
    return render_template('index.html')

@app.route('/about')
def about():
    return render_template('about.html', environment=ENVIRONMENT)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
