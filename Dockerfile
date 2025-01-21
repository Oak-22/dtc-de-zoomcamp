FROM python:3.9

RUN apt-get install wget
RUN pip install pandas sqlalchemy psycopg2-binary pyarrow

WORKDIR /app

COPY scripts/ingest_data_GPT.py ingest_data_GPT.py

ENTRYPOINT ["python", "ingest_data_GPT.py"]
