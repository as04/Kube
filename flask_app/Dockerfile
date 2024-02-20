# Stage 1: Build the Flask app
FROM python:3.9-slim as builder

# Set the working directory in the container
WORKDIR /app

# Copy only the requirements file to the container
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code to the container
COPY . .

# Stage 2: Create the runtime image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy only the installed dependencies from the previous stage
COPY --from=builder /usr/local/lib/python3.9/site-packages/ /usr/local/lib/python3.9/site-packages/
COPY --from=builder /usr/local/bin/gunicorn /usr/local/bin/gunicorn

# Copy the application code from the previous stage
COPY --from=builder /app .

# Expose port 5000
EXPOSE 8000

# Define the command to run the Flask app using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]
