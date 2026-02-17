# use Python 3.12 slim image as base
FROM python:3.12-slim

# set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PATH="/app/.venv/bin:$PATH"

# set working directory
WORKDIR /app

# install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# copy dependencies files and source code
COPY pyproject.toml .
COPY main.py ./    

# install dependencies using uv
RUN pip install uv && uv pip install --system fastmcp

# create non-root user
RUN groupadd -r appuser && useradd -r -g appuser appuser
RUN chown -R appuser:appuser /app
USER appuser

# expose port
EXPOSE 8000

# health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries= \
    CMD python -c "import fastmcp; print('health check passed')" || exit 1

# run the application
CMD ["python", "main.py"]    

# labels for metadata
LABEL maintainer="aalmero" \
      version="1.0.0" \
      description="A sample FastMCP application running in a Docker container" 