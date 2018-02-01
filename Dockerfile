# build stage
FROM golang:alpine AS build-env
COPY . /build
WORKDIR /build
# Git needed for 'go get' for fetching dependencies
RUN apk add --no-cache git mercurial

# Build Go backend
WORKDIR /build/backend
RUN . ./build.sh


# Final stage only copy the files needed from previous step and use smaller base image (drops image size from 500MB to 18MB)
FROM alpine
WORKDIR /app
COPY --from=build-env /build/backend/goapp /app/backend/
COPY --from=build-env /build/backend/templates /app/backend/templates
COPY --from=build-env /build/elm-client/dist /app/elm-client/dist
WORKDIR /app/backend
CMD ./goapp