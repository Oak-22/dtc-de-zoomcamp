#!/usr/bin/env python
# coding: utf-8

import os
import argparse
from time import time
import pandas as pd
from sqlalchemy import create_engine


def main(parameters):
    user = parameters.user
    password = parameters.password
    host = parameters.host
    port = parameters.port
    db = parameters.db
    table_name = parameters.table_name
    url = parameters.url

    # Determine the file name and extension from the URL
    file_name = url.split('/')[-1]
    file_extension = file_name.split('.')[-1]

    # Download the file
    print(f"Downloading file from {url}...")
    os.system(f"wget {url} -O {file_name}")

    # Connect to PostgreSQL
    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')
    print(f"Connected to database: {db}")

    # Read and process the file based on its format
    if file_extension == 'parquet':
        print("Processing Parquet file...")
        df = pd.read_parquet(file_name, engine="pyarrow")
    elif file_extension == 'csv':
        print("Processing CSV file...")
        df = pd.read_csv(file_name)
    else:
        raise ValueError(f"Unsupported file format: {file_extension}")

    # Convert datetime columns if they exist
    if 'tpep_pickup_datetime' in df.columns and 'tpep_dropoff_datetime' in df.columns:
        df['tpep_pickup_datetime'] = pd.to_datetime(df['tpep_pickup_datetime'])
        df['tpep_dropoff_datetime'] = pd.to_datetime(df['tpep_dropoff_datetime'])

    # Write data to the PostgreSQL table
    print(f"Inserting data into the table: {table_name}")
    df.to_sql(name=table_name, con=engine, if_exists='replace', index=False)
    print("Data ingestion complete.")


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Ingest data to Postgres')

    parser.add_argument('--user', help='Username for Postgres', required=True)
    parser.add_argument('--password', help='Password for Postgres', required=True)
    parser.add_argument('--host', help='Host for Postgres', required=True)
    parser.add_argument('--port', help='Port for Postgres', required=True)
    parser.add_argument('--db', help='Database name for Postgres', required=True)
    parser.add_argument('--table_name', help='Name of the table to write results to', required=True)
    parser.add_argument('--url', help='URL of the data file (CSV or Parquet)', required=True)

    args = parser.parse_args()

    main(args)
