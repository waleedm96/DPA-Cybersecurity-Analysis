FROM quay.io/jupyter/pyspark-notebook:c9ecde976a5f
WORKDIR /home/jovyan/work
COPY --chown=1000:100 . .
RUN pip install --no-cache-dir -r requirements.txt
