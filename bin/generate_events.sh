#!/bin/bash

export KAFKA_HOME=/Users/Simon/DockerMachines/wp_elk/kafka
export KAFKA_HOST=kafka
export KAFKA_PORT=9092
export KAFKA_EXTERNAL_PORT=29092
export AFDROP_PORT=9000
export KAFKA_CLEARING_INTERNAL_TOPIC_NAME=clearing-internal

total=100
count=1

echo "creating $total events"

while [ $count -le $total ]
do
  uuid=$(uuidgen | tr "[A-Z]" "[a-z]"  )
  echo $uuid
  docker exec -e PGPASSWORD='clearing' -d postgres-clearing_clearing-db_1 psql -h localhost -p 5432 -U clearing -c  "INSERT INTO payment (id,merchant_id,total_value,currency,scheme,paid_at,status) VALUES('$uuid', '27d2aadb-c444-4788-9195-5a42715a1d13', '10000', 'GBP', 'VISA', current_timestamp, 'NEW')"
  java -jar ../target/gs-maven-0.1.0.jar publish $uuid
  ((count++))
done
