# routes/messages.py

from flask import Blueprint, jsonify, request
from models import database
import uuid
import logging
from logging_config import setup_logging


messages_bp = Blueprint("messages", __name__)
logger = setup_logging()

# logging.basicConfig(level=logging.INFO)
# logger = logging.getLogger(__name__)

@messages_bp.route("/get/messages/<account_id>")
def get_messages(account_id):
    try:
        # print("get msgs account id", account_id)
        filtered_messages = database.get_all_messages(account_id)
        # filtered_messages = [msg for msg in messages if msg["account_id"] == account_id]
        response = [
        {"account_id": item[0], "message_id": item[1], "sender_number": item[2], "receiver_number": item[3]}
        for item in filtered_messages
        ]
        return jsonify(response)
    except Exception as e:
        # Log any exceptions that occur
        logger.error(f"Error occurred in get_messages route: {e}")
        # Return error response
        return jsonify({"error": "An error occurred"}), 500

@messages_bp.route("/create", methods=["POST"])
def create_message():
    print("-----Create------", request)
    data = request.json
    # print(data)
    account_id = data.get("account_id")
    sender_number = data.get("sender_number")
    receiver_number = data.get("receiver_number")
    message_id = data.get("message_id")
    if not all([account_id, sender_number, receiver_number]):
        logger.error("Missing required fields in the request")
        return jsonify({"error": "Missing required fields"}), 400
    database.create_message(account_id, sender_number, receiver_number, message_id)

    logger.info("Message created successfully")
    return jsonify({"message": "Message created successfully"}), 201

@messages_bp.route('/search', methods=['GET'])
def search():
    try:
        # Get the filter parameters from the query string
        message_ids = request.args.get('message_id')
        sender_numbers = request.args.get('sender_number')
        receiver_numbers = request.args.get('receiver_number')
        
        # Call the search_messages function from the models
        matching_messages = database.search_messages(message_ids, sender_numbers, receiver_numbers)
        response = [
        {"account_id": item[0], "message_id": item[1], "sender_number": item[2], "receiver_number": item[3]}
        for item in matching_messages
        ]
        
        return jsonify(response)
    except Exception as e:
        # Log any exceptions that occur
        logger.error(f"Error occurred in search route: {e}")
        # Return error response
        return jsonify({"error": "An error occurred"}), 500


