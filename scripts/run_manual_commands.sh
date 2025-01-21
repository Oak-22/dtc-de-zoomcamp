## 'pgadmin-container' creation


# Self-sufficient docker run command that will pull base image pgadmin 4 from Docker Hub (if not avail locally), set the environmental
# variables to configure the deafult email and password, as well as map port 8080 (from my host machine)
# onto port 80 inside the container. This will locally host and run pgAdmin for viewing in browser.
docker run -it \
  -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
  -e PGADMIN_DEFAULT_PASSWORD="root" \
  -p 8080:80 \ # Browser requests to http://localhost:8080 are sent to host port 8080, forwarded to container port 80 (via -p 8080:80), processed by the pgadmin-container, and the response is returned to the browser.
  --name pgadmin-container \
  dpage/pgadmin4


## Network


# 'docker network create' to connect pgAdmin (postgresql management tool) to our Docker-contained
# ...PostgreSQL database 'ny_taxi'.

docker network create pg-network




# Run a PostgreSQL 17 Alpine container with a specified database, user, and password, and persistent volume mapping
# This container cites the docker network "pg-network"
docker run -it \
  -e POSTGRES_DB=ny_taxi \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -v vol-pgdata:/var/lib/povstgresql/data \ #Creates a persistent volume named vol-pgdata. Maps the PostgreSQL data directory inside the container (/var/lib/postgresql/data) to the volume
  -p 5432:5432 \ # Maps port 5432 from my local machine to the 5432 port in the container 
  --network=pg-network \ # Specifies the Docker network to enable communication between the containerized database and pgAdmin
  --name pg-database \ # Specify the name of how pgAdmin discover postgres
  postgres:17-alpine

# Docker run command above without in-line comments

docker run -it \
  -e POSTGRES_DB=ny_taxi \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -v vol-pgdata:/var/lib/postgresql/data \
  -p 5432:5432 \
  --network=pg-network \
  --name pg-database \
  postgres:17-alpine



# Command to execute the ingest_data.py script with required arguments passed at runtime

URL="https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2021-01.parquet"


python ingest_data_GPT.py \
    --user=postgres \
    --password=postgres \
    --host=localhost \
    --port=5432 \
    --db=ny_taxi \
    --table_name=yellow_taxi_data \
    --url="https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2021-01.parquet"




## Ingesting data to Dockerized Postgresql db



# docker build: Creates the Docker image for data ingestion

docker build -t taxi_ingest:v001 .


# docker run: Creates a container from the 'taxi_ingest:v001' image and passes required arguments.
# Arguments include database credentials + dataset URL for extracting and ingesting data into PostgreSQL.

docker run -it --network=pg-network --name=taxi-ingestcontainer taxi_ingest:v001 \
    --user=postgres \
    --password=postgres \
    --host=host.docker.internal \ # Changed from 'localhost' to 'host.docker.internal'
    --port=5432 \
    --db=ny_taxi \
    --table_name=yellow_taxi_data \
    --url="https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2021-01.parquet"