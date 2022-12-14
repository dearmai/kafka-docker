#!/bin/bash -e

source version.sh
BASE_IMAGE="dearmai/kafka"
TARGET="$BASE_IMAGE:v${KAFKA_VERSION}"

# Build for amd64 and arm64
PLATFORMS="linux/amd64,linux/arm64"

EXTRA_BUILDX_ARGS=$@
CACHE_LOCATION="/tmp/docker-cache"

if [[ "${EXTRA_BUILDX_ARGS}" == *"--load"* ]]; then
    # We have to load the image for the current architecture only in order to run tests, so let's
    # pull FROM the multi-arch build that happened previously
    PLATFORMS="linux/${TRAVIS_CPU_ARCH}"
    CACHE="--cache-from=type=local,src=${CACHE_LOCATION}"
elif [[ "${EXTRA_BUILDX_ARGS}" == *"--push"* ]]; then
    # Push ALL architectures FROM the multi-arch build cache that happened previously
    CACHE="--cache-from=type=local,src=${CACHE_LOCATION}"
else
    # This is the multi-arch build that we should cache and use later
    CACHE="--cache-to=type=local,dest=${CACHE_LOCATION}"
fi

docker buildx build \
    --platform "${PLATFORMS}" \
    --progress=plain \
    --build-arg kafka_version=$KAFKA_VERSION \
    --build-arg scala_version=$SCALA_VERSION \
    --build-arg vcs_ref=$TRAVIS_COMMIT \
    --build-arg build_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
    -t ${TARGET} \
    --push \
    .

# docker buildx build \
#     $CACHE \
#     --platform "${PLATFORMS}" \
#     --progress=plain \
#     --build-arg kafka_version=$KAFKA_VERSION \
#     --build-arg scala_version=$SCALA_VERSION \
#     --build-arg vcs_ref=$TRAVIS_COMMIT \
#     --build-arg build_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
#     -t dearmai/kafka \
#     --push \
#     .