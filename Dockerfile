# You can find the included packages for Alpine version from: https://pkgs.alpinelinux.org/packages?name=go*&branch=v3.8
# If you want older version of a package you need to add the older repositoty too
# echo 'http://dl-cdn.alpinelinux.org/alpine/v3.1/main' >> /etc/apk/repositories


# Start with the Alpine linux with glibc as there seems to be issues with elm with the Musl 
FROM frolvlad/alpine-glibc as build-env
COPY . /build
WORKDIR /build

# Environment variables controlling the build
## Use specific GO version to be consisted with local development
ARG GO_VERSION 

###################################################
# Installing packages needed for building the app #
###################################################

## Install GO
## Using older GO version (1.9.4) from Alpine 3.7
RUN echo '@alpine37 http://nl.alpinelinux.org/alpine/v3.7/community' >> /etc/apk/repositories
RUN apk add go@alpine37
RUN echo 'Verify Go version to be: ' $GO_VERSION
RUN go version
RUN go version | grep $GO_VERSION 

## Git needed for 'go get' for fetching dependencies
RUN apk add --no-cache git mercurial

## Needed for govendor
RUN apk add --no-cache musl-dev

## Elm client built with webpack over npm
RUN apk add --no-cache npm


####################
# Build Go backend #
####################
WORKDIR /build/backend
RUN . ./build.sh

# Build Elm frontend
# Compiles the Elm client as javascript to /dist
WORKDIR /build/elm-client
RUN . ./build.sh

# Final stage only copy the files needed from previous step and use smaller base image (drops image size from 500MB to 18MB)
FROM frolvlad/alpine-glibc
WORKDIR /app
COPY --from=build-env /build/backend/stmApp /app/backend/
COPY --from=build-env /build/backend/templates /app/backend/templates
COPY --from=build-env /build/elm-client/dist /app/elm-client/dist
WORKDIR /app/backend
CMD ./stmApp
