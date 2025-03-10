# Use an official Python 3.7 slim image as the base image
FROM python:3.7-slim

# Install system packages required for building and running the app
RUN apt-get update && apt-get install -y \
    build-essential \
    python3-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install pipenv globally
RUN pip install pipenv

# Set the working directory
WORKDIR /app

# Copy the project files into the container
COPY . /app

# Install the Python dependencies using pipenv
# --deploy ensures that the Pipfile.lock is used (fail if out-of-date)
RUN pipenv install --deploy --ignore-pipfile

# (Optional) Copy example.env to .env if no external .env is provided.
# You might want to override .env later via volumes or environment variables.
RUN cp example.env .env

# Expose the port if your app runs a web server (adjust as needed)
EXPOSE 8000

# Set the default command.
# For development, this runs the development server with automatic restarts.
# Change "dev" to "parse" or another command as needed.
CMD ["pipenv", "run", "./run.sh", "dev"]
