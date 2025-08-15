# Stage 1: Build stage
FROM python:3.9-slim AS build

# Set working directory
WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    default-libmysqlclient-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install them
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY app.py dbcontext.py person.py ./
COPY static/ static/
COPY templates/ templates/

# Stage 2: Final image
FROM python:3.9-slim

WORKDIR /app

# Copy installed packages from build stage
COPY --from=build /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
COPY --from=build /app /app

# Expose port
EXPOSE 5000

# Start the application
CMD ["python", "app.py"]
