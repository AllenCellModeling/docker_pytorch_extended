#!/usr/bin/env bash

# tag the image with the current git branch name
TAG=${1%/}
KWARGS=${2}

cd ${TAG}

# and build
docker build ${KWARGS} -t rorydm/pytorch_extras:${TAG} -f Dockerfile .

