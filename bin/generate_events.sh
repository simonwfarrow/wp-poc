#!/bin/bash

export KAFKA_HOME=/Users/Simon/DockerMachines/wp_elk/kafka
export KAFKA_HOST=kafka
export KAFKA_PORT=9092
export KAFKA_EXTERNAL_PORT=29092
export AFDROP_PORT=9000
export KAFKA_CLEARING_INTERNAL_TOPIC_NAME=clearing-internal

total=50
count=1
uuids=''
sql=''
lcp='UK_PO1100000001'
muid='861edc23-ae0e-4a1d-84c8-c6aa98fb284e'
#lcp='BV_PO1100000002'
#muid='27d2aadb-c444-4788-9195-5a42715a1d13'

echo "creating $total events"

while [ $count -le $total ]
do
  uuid=$(uuidgen | tr "[A-Z]" "[a-z]"  )
  uuids+=$uuid','
  sql+='('\'$uuid\'', '\'$muid\'', '\'$RANDOM\'', '\'GBP\'', '\'VISA\'', current_timestamp, '\'NEW\'','\'$lcp\''),'
  ((count++))
done

sql=${sql%?}

echo 'creating the following uuids'
echo $uuids

docker exec -e PGPASSWORD='clearing' -d postgres-clearing_clearing-db_1 psql -h localhost -p 5432 -U clearing -c  "INSERT INTO payment (id,merchant_id,total_value,currency,scheme,paid_at,status,lcp) VALUES$sql"
java -jar ../target/gs-maven-0.1.0.jar publish $uuids
