#!/bin/sh
<<HEADER
*******************************************************************************************
Author:         Steve Howard
Date:           April 20, 2020
Purpose:        Cleanup KSQL application objects
Revisions:      2020-04-20 - Initial copy (SDH)
*******************************************************************************************
HEADER

echo "list queries;" | \
  ksql | \
  awk '$1 ~ "^CSA|^CTA|InsertQuery" {print "terminate",$1";"}' > queries.txt

cat queries.txt | ksql

echo "list streams;" | \
  ksql | \
  awk '{if ($0 ~ "Stream Name") {prnt=1;} else if(prnt==1 && length($0) > 1 && $1 != "ksql>" && $1 != "KSQL_PROCESSING_LOG") {print "drop stream",$1";"}}' > streams.txt

cat streams.txt | ksql

echo "list tables;" | \
  ksql | \
  awk '{if ($0 ~ "Table Name") {prnt=1;} else if(prnt==1 && length($0) > 1 && $1 != "ksql>" && $1 != "KSQL_PROCESSING_LOG") {print "drop table",$1";"}}' > tables.txt

cat tables.txt | ksql
