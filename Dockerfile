FROM python:3.9-slim

# Establish a working folder
WORKDIR /app

# Establish dependencies
COPY requirements.txt .
RUN python -m pip install -U pip wheel && \
    pip install --no-cache-dir -r requirements.txt

# Copy source files last because they change the most
COPY service ./service

# Become non-root user
RUN useradd -m -r service && \
    chown -R service:service /app
USER service

# Set environment variables
ENV PORT 8000
EXPOSE $PORT

# Command to run the application
CMD ["gunicorn", "service:app", "--bind", "0.0.0.0:8000"]
