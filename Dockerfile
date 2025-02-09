# Use official Python base image
FROM python:3.9-alpine3.13

# Set the maintainer label
LABEL maintainer="londonappdeveloper.com"

# Ensure output is sent directly to the terminal
ENV PYTHONUNBUFFERED=1

# Set default shell for Alpine
SHELL ["/bin/sh", "-c"]

# Set working directory
WORKDIR /app

# Copy dependencies files first (to leverage caching)
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# Copy application code
COPY ./app /app

# Expose the application port
EXPOSE 8000

# Define build argument for development mode
ARG DEV=false

# Install dependencies and create a virtual environment
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install --no-cache-dir -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; then \
        /py/bin/pip install --no-cache-dir -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /tmp && \
    adduser --disabled-password --no-create-home django-user

# Set environment variables
ENV PATH="/py/bin:$PATH"

# Use non-root user for security
USER django-user