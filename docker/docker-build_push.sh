#!/bin/bash -e

source version.sh
BASE_IMAGE="dearmai/kafka"
TARGET="$BASE_IMAGE:v${KAFKA_VERSION}"

docker build \
    --build-arg kafka_version=$KAFKA_VERSION \
    --build-arg scala_version=$SCALA_VERSION \
    --build-arg build_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
    -t ${TARGET} \
    .

docker push ${TARGET}