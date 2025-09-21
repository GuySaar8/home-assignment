import unittest
from app import app, db


class TestFlaskApp(unittest.TestCase):
    def setUp(self):
        self.app = app.test_client()
        self.app.testing = True

        # Initialize database for testing
        with app.app_context():
            db.create_all()

    def tearDown(self):
        # Clean up database after each test
        with app.app_context():
            db.drop_all()

    def test_home_status_code(self):
        """Test that home page loads successfully"""
        response = self.app.get('/')
        self.assertEqual(response.status_code, 200)

    def test_about_page_status_code(self):
        """Test that about page loads successfully"""
        response = self.app.get('/about')
        self.assertEqual(response.status_code, 200)

    def test_about_page_environment_variable(self):
        """Test that environment is displayed on about page"""
        response = self.app.get('/about')
        self.assertIn(b'Current Environment', response.data)


if __name__ == '__main__':
    unittest.main()
