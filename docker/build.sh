#!/bin/bash
set -e
echo "Building the docker image"

if [[ -z "${STM_GO_VERSION}" ]]; then
 	echo "Missing env variable STM_GO_VERSION for build"
	exit 1
fi

docker build --tag supertimemachine --build-arg STM_GO_VERSION=$STM_GO_VERSION ../

