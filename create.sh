#!/bin/sh

confluent local stop
rm -rf /tmp/confluent*
sleep 5
confluent local start

kafka-topics --create --bootstrap-server localhost:9092 --topic accounts
kafka-topics --create --bootstrap-server localhost:9092 --topic sub-accounts
kafka-topics --create --bootstrap-server localhost:9092 --topic accounts-all
kafka-topics --create --bootstrap-server localhost:9092 --topic hybris.poc.consignment1

s=$(cat account.json)
echo $s | kafka-console-producer --bootstrap-server localhost:9092 --topic accounts
s=$(cat account-sub-type.json)
echo $s | kafka-console-producer --bootstrap-server localhost:9092 --topic sub-accounts
s=$(cat poc_consignment.json)
echo $s | kafka-console-producer --bootstrap-server localhost:9092 --topic hybris.poc.consignment1

cat consignment-events-create.ksql | ksql
cat combined-accounts.ksql | ksql

