
FROM jupyter/pyspark-notebook

# Display Python output immediately in Docker logs
ENV PYTHONUNBUFFERED=1

# Remove the base image's default work directory
RUN if [ -d /home/jovyan/work ]; then \
    rm -rf /home/jovyan/work; \
    fi

# Copy the project with notebook-user permissions
COPY --chown=1000:100 . /home/jovyan/dpa_volume

WORKDIR /home/jovyan/dpa_volume

# Install project-specific dependencies
RUN pip install --no-cache-dir -r requirements.txt
