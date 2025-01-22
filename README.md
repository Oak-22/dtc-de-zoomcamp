### 2024 Homework (OLD)

# Module 1 Homework (OUTDATED---> 2025 WORK IS BELOW THIS ENTRY)



Question 1. Knowing docker tags

Which tag has the following text? - Automatically remove the container when it exits

    --delete 
        --rc 
        --rmd
        --rm  Automatically remove the container and its associated anonymous volumnes when it exits.
    
    Answer: --rm



Question 2. Understanding docker first run

What is version of the package wheel?

Answer: 0.42.0 (currently version 0.45.1)



Question 3. Count records

How many taxi trips were totally made on September 18th 2019?

SELECT COUNT(*) AS number_of_trips
FROM green_taxi_data
WHERE 
    DATE(lpep_pickup_datetime) = '2019-09-18';

Answer: 15767

Question 4. Longest trip for each day

Which was the pick up day with the longest trip distance? Use the pick up time for your calculations.

SELECT DATE(lpep_pickup_datetime) AS Date, MAX(trip_distance)
FROM green_taxi_data
GROUP BY DATE(lpep_pickup_datetime)
ORDER BY MAX(trip_distance) DESC
LIMIT 1;

Answer: 09-26-2019 

Question 5. Three biggest pick up Boroughs

Consider lpep_pickup_datetime in '2019-09-18' and ignoring Borough has Unknown

Which were the 3 pick up Boroughs that had a sum of total_amount superior to 50000?

Answer: None (result set returned no Borough names)


Question 6. Largest tip

For the passengers picked up in September 2019 in the zone name Astoria which was the drop off zone that had the largest tip? We want the name of the zone, not the id. 

SELECT z2."Zone", MAX(tip_amount) 
FROM green_taxi_data g
LEFT JOIN zones z1 ON g."PULocationID" = z1."LocationID"
LEFT JOIN zones z2 ON g."DOLocationID" = z2."LocationID"
WHERE z1."Zone" = 'Astoria'
  AND DATE(g.lpep_pickup_datetime) BETWEEN '2019-09-01' AND '2019-09-30'
GROUP BY z2."Zone"
ORDER BY MAX(tip_amount) DESC
LIMIT 1;

Answer: JFK Airport - $62.31

Question 7. Terraform Workflow

Answer:  terraform init, terraform apply -auto-approve, terraform destroy






----------------------------------------------------------------------------------------------






### 2025 Homework

# Module 1 Homework: Docker & SQL



Question 1. Understanding docker first run

Run docker with the python:3.12.8 image in an interactive mode, use the entrypoint bash.

What's the version of pip in the image?

BASH
docker run -it python:3.12.8 bash

root@ec57375cfba7:/# pip list

Answer: 24.3.1




Question 2. Understanding Docker networking and docker-compose

Given the following docker-compose.yaml, what is the hostname and port that pgadmin should use to connect to the postgres database?

services:
  db:
    container_name: postgres
    image: postgres:17-alpine
    environment:
      POSTGRES_USER: 'postgres'
      POSTGRES_PASSWORD: 'postgres'
      POSTGRES_DB: 'ny_taxi'
    ports:
      - '5433:5432'
    volumes:
      - vol-pgdata:/var/lib/postgresql/data

  pgadmin:
    container_name: pgadmin
    image: dpage/pgadmin4:latest
    environment:
      PGADMIN_DEFAULT_EMAIL: "pgadmin@pgadmin.com"
      PGADMIN_DEFAULT_PASSWORD: "pgadmin"
    ports:
      - "8080:80"
    volumes:
      - vol-pgadmin_data:/var/lib/pgadmin  

volumes:
  vol-pgdata:
    name: vol-pgdata
  vol-pgadmin_data:
    name: vol-pgadmin_data


Answer: postgres:5432



Question 3. Trip Segmentation Count

During the period of October 1st 2019 (inclusive) and November 1st 2019 (exclusive), how many trips, respectively, happened:

Up to 1 mile
In between 1 (exclusive) and 3 miles (inclusive),
In between 3 (exclusive) and 7 miles (inclusive),
In between 7 (exclusive) and 10 miles (inclusive),
Over 10 mile

SQL query:

SELECT
    COUNT(CASE WHEN trip_distance <= 1 THEN 1 END) as "Up to 1 mile",
    COUNT(CASE WHEN trip_distance > 1 AND trip_distance <= 3 THEN 1 END) as "1-3 miles",
    COUNT(CASE WHEN trip_distance > 3 AND trip_distance <= 7 THEN 1 END) as "3-7 miles",
    COUNT(CASE WHEN trip_distance > 7 AND trip_distance <= 10 THEN 1 END) as "7-10 miles",
    COUNT(CASE WHEN trip_distance > 10 THEN 1 END) as "Over 10 miles"
FROM green_taxi_data
WHERE pep_pilckup_datetime >= '2019-10-01 00:00:00' AND lpep_dropoff_datetime < '2019-11-01 00:00:00';


Answer: 104,802; 198,924; 109,603; 27,678; 35,189



Question 4. Longest trip for each day

Which was the pick up day with the longest trip distance? Use the pick up time for your calculations.

SELECT
    lpep_pickup_datetime,
    trip_distance
FROM green_taxi_data
WHERE DATE(lpep_pickup_datetime) = '2019-10-31'
ORDER BY trip_distance DESC
LIMIT 1;


Answer: 2019-10-31


Question 5. Three biggest pickup zones


Which were the top pickup locations with over 13,000 in total_amount (across all trips) for 2019-10-18?

SQL query:

SELECT
    z."Zone" AS pickup_zone,
    SUM(g."total_amount") AS total_revenue
FROM
    green_taxi_data g
JOIN
    taxi_zone_lookup z
ON
    g."PULocationID" = z."LocationID"
WHERE
    DATE(g."lpep_pickup_datetime") = '2019-10-18'
GROUP BY
    z."Zone"
HAVING
    SUM(g."total_amount") > 13000
ORDER BY
    total_revenue DESC
LIMIT 3;


Answer: East Harlem North, East Harlem South, Morningside Heights




Question 6. Largest tip


For the passengers picked up in October 2019 in the zone named "East Harlem North" which was the drop off zone that had the largest tip?

SQL query: 

SELECT
    z_dropoff."Zone" AS dropoff_zone,
    MAX(g."tip_amount") AS largest_tip
FROM
    green_taxi_data g
JOIN
    taxi_zone_lookup z_pickup
ON
    g."PULocationID" = z_pickup."LocationID"
JOIN
    taxi_zone_lookup z_dropoff
ON
    g."DOLocationID" = z_dropoff."LocationID"
WHERE
    z_pickup."Zone" = 'East Harlem North' AND
    DATE(g."lpep_pickup_datetime") BETWEEN '2019-10-01' AND '2019-10-31'
GROUP BY
    z_dropoff."Zone"
ORDER BY
    largest_tip DESC
LIMIT 1;



Answer: JFK Airport




Question 7. Terraform Workflow

which of the following sequences, respectively, describes the workflow for:

Downloading the provider plugins and setting up backend,
Generating proposed changes and auto-executing the plan
Remove all resources managed by terraform`

Answer: terraform init, terraform apply -auto-approve, terraform destroy

