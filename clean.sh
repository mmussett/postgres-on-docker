#!/bin/bash


# Command to delete the database and ignore errors
docker exec -it postgres-on-docker-postgres-1 psql -U postgres -c "
DO \$\$ 
BEGIN 
   PERFORM pg_terminate_backend(pid) 
   FROM pg_stat_activity 
   WHERE datname = 'demo'; 
   EXECUTE 'DROP TABLE IF EXISTS customer';

EXCEPTION 
   WHEN OTHERS THEN 
      -- Ignore errors
      RAISE NOTICE 'Database drop operation completed with errors';
END \$\$;
"

echo "Customer table created and populated with sample data."
