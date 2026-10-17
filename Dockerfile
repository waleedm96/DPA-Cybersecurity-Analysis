
FROM jupyter/pyspark-notebook:spark-3.5.0

# Display Python output immediately in Docker logs
ENV PYTHONUNBUFFERED=1
ENV SPARK_CONF_DIR=/home/jovyan/Dpa-Cybersecurity-Analysis/config
# Make PySpark available to both notebook kernels and docker compose exec.
ENV PYTHONPATH=/usr/local/spark/python:/usr/local/spark/python/lib/py4j-0.10.9.7-src.zip

# Remove the base image's default work directory
RUN if [ -d /home/jovyan/work ]; then \
    rm -rf /home/jovyan/work; \
    fi

# Copy the project with notebook-user permissions
COPY --chown=1000:100 . /home/jovyan/Dpa-Cybersecurity-Analysis

WORKDIR /home/jovyan/Dpa-Cybersecurity-Analysis

# Install project-specific dependencies
RUN pip install --no-cache-dir -r requirements.txt
