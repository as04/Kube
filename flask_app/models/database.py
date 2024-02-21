# backend/database.py

import mysql.connector
import logging
import os
from logging_config import setup_logging


# logging.basicConfig(level=logging.INFO)
# logger = logging.getLogger(__name__)
logger = setup_logging()


# Define the connection parameters for MySQL
DB_USER = os.environ['DB_USER']  # MySQL username
DB_PASSWORD = os.environ['DB_PASSWORD']  # MySQL password
DB_HOST = os.environ['DB_HOST']  # MySQL host (localhost) 
DB_PORT = os.environ['DB_PORT']  # The exposed port of your MySQL Docker container
DB_NAME = os.environ['DB_NAME'] # Replace 'your_database_name' with the actual database name

def get_db_connection():

    # Print out environment variables
    logger.info(f"DB_USER: {DB_USER}")
    logger.info(f"DB_PASSWORD: {DB_PASSWORD}")
    logger.info(f"DB_HOST: {DB_HOST}")
    logger.info(f"DB_PORT: {DB_PORT}")
    logger.info(f"DB_NAME: {DB_NAME}")

    try:
        conn = mysql.connector.connect(
                user=DB_USER,
                password=DB_PASSWORD,
                host=DB_HOST,
                port=DB_PORT,
                database=DB_NAME
            )
        logger.info("Connected to MySQL database successfully.")
    except Error as e:
        logger.error("Failed to connect to MySQL database: %s", e)
    return conn

def create_database_table():
    try:
        conn = get_db_connection()
        logger.info("Connected to MySQL database successfully.")

        # Create table if not exists upon establishing connection
        create_table_query = """
            CREATE TABLE IF NOT EXISTS messages (
                account_id VARCHAR(255),
                message_id VARCHAR(255) PRIMARY KEY,
                sender_number VARCHAR(20),
                receiver_number VARCHAR(20)
            )
        """
        cursor = conn.cursor()
        cursor.execute(create_table_query)
        conn.commit()
        cursor.close()
        conn.close()

    except Exception as e:
        logger.error("Failed to connect to MySQL database: %s", e)

def get_all_messages(account_id):
    try:
        logger.info(f"Fetching all messages for account ID: {account_id}")
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("SELECT * FROM messages WHERE account_id = %s", (account_id,))
        messages = cur.fetchall()
        cur.close()
        conn.close()
        return messages
    except Exception as e:
        # Log any exceptions that occur
        logger.error(f"Error occurred in get_all_messages: {e}")
        # Raise the exception to propagate it
        raise

def create_message(account_id, sender_number, receiver_number, message_id):
    print("------DB Create------", account_id, sender_number, receiver_number)
    conn = get_db_connection()
    cur = conn.cursor()
    try:
        cur.execute(
            "INSERT INTO messages (account_id, message_id, sender_number, receiver_number) VALUES (%s, %s, %s, %s)",
            (account_id, message_id, sender_number, receiver_number)
        )
        conn.commit()
    except Exception as e:
        # Log any database errors
        logger.error(f"Error creating message in the database: {e}")
        conn.rollback()
    finally:
        cur.close()
        conn.close()

def search_messages(message_ids, sender_numbers, receiver_numbers):
    conn = None
    cur = None
    try:
        logger.info("Searching messages with filter parameters")
        # Establish a connection to your MySQL database
        conn = get_db_connection()
        cur = conn.cursor()
        
        # Build the SQL query based on the filter parameters
        query = "SELECT * FROM messages WHERE 1"
        params = []

        if message_ids:
            query += " AND message_id IN (%s)"
            params.append(message_ids)
        if sender_numbers:
            query += " AND sender_number IN (%s)"
            params.append(sender_numbers)
        if receiver_numbers:
            query += " AND receiver_number IN (%s)"
            params.append(receiver_numbers)

        # Execute the SQL query
        cur.execute(query, params)
        
        # Fetch the query results
        matching_messages = cur.fetchall()
        return matching_messages
    except Exception as e:
        # Log any exceptions that occur
        logger.error(f"Error occurred in search_messages: {e}")
        # Raise the exception to propagate it
        raise
    finally:
        # Close the cursor and connection in a finally block to ensure they are always closed
        if cur:
            cur.close()
        if conn:
            conn.close()

create_database_table()
