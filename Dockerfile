# Base image: Python 3.11 on a lightweight Debian (slim) to keep the image small
FROM python:3.11-slim

# Prevent Python from creating .pyc files and ensure logs appear in real time
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set the working directory inside the container
WORKDIR /app

# Create a non-root user for security — the app should never run as root
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

# Install dependencies first (Docker caches this layer if requirements.txt hasn't changed)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Make the entrypoint script executable (it runs migrations and starts gunicorn)
RUN chmod +x entrypoint.sh

# Give ownership of all files to the non-root user
RUN chown -R appuser:appgroup /app

# Switch to the non-root user from this point on
USER appuser

# Document the port the app listens on
EXPOSE 8000

# Health check: Docker/K8s will ping this endpoint every 30s to make sure the app is alive
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/api/users/')" || exit 1

# Start the app using the entrypoint script (migrate + gunicorn)
ENTRYPOINT ["./entrypoint.sh"]
