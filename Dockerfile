# Use an official Python 3.7 slim image as the base image
FROM python:3.7-slim

# Install system packages required for building and running the app
RUN apt-get update && apt-get install -y \
    build-essential \
    python3-dev \
    git \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Install pipenv globally
RUN pip install pipenv

# Set the working directory
WORKDIR /app

# Copy the project files into the container
COPY . /app

# Install the Python dependencies using pipenv
RUN pipenv install --deploy --ignore-pipfile

# Create .env from example.env and replace the ChangeMe placeholders with generated values.
# A 16-byte hex string is used for ADMIN_PASS and a 32-byte hex string for SECRET_KEY.
RUN cp example.env .env && \
    ADMIN_PASS=$(openssl rand -hex 16) && \
    SECRET_KEY=$(openssl rand -hex 32) && \
    sed -i "s/ADMIN_PASS=ChangeMe/ADMIN_PASS=${ADMIN_PASS}/" .env && \
    sed -i "s/SECRET_KEY=ChangeMe/SECRET_KEY=${SECRET_KEY}/" .env

# Expose the port if your app runs a web server (adjust as needed)
EXPOSE 8000

# Set the default command. Adjust the command (e.g., "dev", "parse") as needed.
CMD ["pipenv", "run", "./run.sh", "dev"]
