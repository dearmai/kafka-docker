#!/bin/bash

cd /app/kafka

if [ -z ${USE_ZOOKEEPER} ]; then
  kafka-server-start.sh config/server.properties
else
  zookeeper-server-start.sh config/zookeeper.properties
fi