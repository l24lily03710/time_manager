#!/bin/bash

docker stop phoenix-postgres
docker rm phoenix-postgres

docker volume rm $(docker volume ls -qf "name=postgres-data")

docker run --name phoenix-postgres -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -p 5500:5432 -d postgres
