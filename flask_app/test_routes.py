import unittest
from flask import json
from app import app

class TestMessageRoutes(unittest.TestCase):
    def setUp(self):
        self.app = app.test_client()

    def test_get_messages(self):
        # Mock database response
        expected_response = [
            {"account_id": "3", "message_id": "5", "sender_number": "1234567891", "receiver_number": "9876543210"},
            {"account_id": "3", "message_id": "12", "sender_number": "1234567890", "receiver_number": "9876543210"}
        ]
        # Make a GET request to the route
        response = self.app.get('/get/messages/3')
        # Convert JSON response to dict
        data = json.loads(response.data)
        # Check status code
        self.assertEqual(response.status_code, 200)
        # Check if the response data matches the expected data
        self.assertEqual(data, expected_response)

    # def test_create_message(self):
        # Prepare request data
        # data = {"account_id": "3","message_id": "5", "sender_number": "123", "receiver_number": "456"}
        # # Make a POST request to the route
        # response = self.app.post('/create', json=data)
        # # Check status code
        # self.assertEqual(response.status_code, 201)
        # # Check if the response message indicates successful creation
        # self.assertEqual(json.loads(response.data), {"message": "Message created successfully"})

    def test_search_messages(self):
        # Mock database response
        expected_response = [
            {"account_id":"3","message_id":"5","receiver_number":"9876543210","sender_number":"1234567891"}
        ]
        # Make a GET request to the route with query parameters
        response = self.app.get('/search?message_id=5&sender_number=1234567891')
        # Convert JSON response to dict
        data = json.loads(response.data)
        # Check status code
        self.assertEqual(response.status_code, 200)
        # Check if the response data matches the expected data
        self.assertEqual(data, expected_response)

if __name__ == '__main__':
    unittest.main()
