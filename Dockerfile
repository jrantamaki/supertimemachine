# build stage
FROM golang:alpine AS build-env
COPY . /build
WORKDIR /build
# Git needed for 'go get' for fetching dependencies
RUN apk add --no-cache git mercurial

# Build Go backend
WORKDIR /build/backend
RUN . ./build.sh
CMD ./goapp
