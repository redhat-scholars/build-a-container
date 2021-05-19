#!/bin/bash

set -euo pipefail

declare IMAGE_NAME=${1}
declare SHELL_TAG=${2:-latest}
declare DOCKERFILE=${3:-Dockerfile}
declare REGISTRY=${4:-"quay.io"}
declare ACCOUNT=${5:-"mhildenb"}

DOCKER_BUILDKIT=1 docker build --progress=plain -f ${DOCKERFILE} -t ${REGISTRY}/${ACCOUNT}/${IMAGE_NAME}:$SHELL_TAG .

docker tag ${REGISTRY}/${ACCOUNT}/${IMAGE_NAME}:${SHELL_TAG} ${REGISTRY}/${ACCOUNT}/${IMAGE_NAME}:latest

docker push ${REGISTRY}/${ACCOUNT}/${IMAGE_NAME}:${SHELL_TAG}
docker push ${REGISTRY}/${ACCOUNT}/${IMAGE_NAME}:latest
