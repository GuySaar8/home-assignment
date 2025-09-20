import unittest
from app import app


class TestFlaskApp(unittest.TestCase):
    def setUp(self):
        self.app = app.test_client()
        self.app.testing = True

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