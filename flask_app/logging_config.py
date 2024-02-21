# logging_config.py

import logging
from logging.handlers import RotatingFileHandler

def setup_logging():
    # Create a logger instance
    logger = logging.getLogger(__name__)
    logger.setLevel(logging.INFO)  # Set the logging level

    # Define the log file path and rotation parameters
    log_file = '/logs/app.log'
    max_file_size_bytes = 10 * 1024 * 1024  # 10 MB
    backup_count = 5  # Number of backup log files to keep

    # Create a RotatingFileHandler and set its parameters
    file_handler = RotatingFileHandler(log_file, maxBytes=max_file_size_bytes, backupCount=backup_count)
    file_handler.setLevel(logging.INFO)  # Set the logging level for the handler

    # Define a log message format
    formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
    file_handler.setFormatter(formatter)

    # Add the file handler to the logger
    logger.addHandler(file_handler)
    
    return logger
