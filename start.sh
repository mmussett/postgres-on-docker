#!/bin/bash

# Start Postgres
docker compose up -d

# Create external service
kubectl apply -n default -f ps-service.yml

# Wait for database to start
echo "Waiting for 10s for database to be ready"
sleep 10s

# Create database
docker exec -it postgres-on-docker-postgres-1 psql -U postgres -c "
DO \$\$
BEGIN
  CREATE DATABASE demo;
EXCEPTION
  WHEN OTHERS THEN
    -- Ignore errors
    RAISE NOTICE 'Database already exists, skipping';
END \$\$
"

docker exec -it postgres-on-docker-postgres-1 psql -U postgres -d demo -c "
DROP TABLE IF EXISTS customer;
CREATE TABLE customer (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    age INT,
    city VARCHAR(100)
);
INSERT INTO customer (name, email, age, city)
VALUES
('John Doe', 'john.doe@example.com', 30, 'New York'),
('Jane Smith', 'jane.smith@example.com', 25, 'Los Angeles'),
('Sam Brown', 'sam.brown@example.com', 40, 'Chicago'),
('Lisa White', 'lisa.white@example.com', 35, 'Houston');
"

echo "Customer table created and populated with sample data."
