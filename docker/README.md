# Docker instructions


## Build configuration
To achieve reliable builds between local and docker container, we need to ensure we use the same versions of dependencies on each. While building the application on docker or locally the dependency versions will be verified.

To set the proper build configuration set the environment variables defined in the [buildConfig](../buildConfig.env). See the section in the [main readme](../README.md) for recommendation on how to do this using (direnv)[https://direnv.net/].

## Building the Docker container
Application is bundled as single Docker container containing both backend and frontend applications.

To build the Docker container run:
`./build.sh`

## Running the Docker container locally
To run the docker container locally run:
`./start.sh`

It will use the env variables defined in the `local.env`.

## Deploying Docker to Heroku

```sh
$ heroku container:login
$ heroku create
$ heroku container:push web
$ heroku apps:info
```

# Docker troubleshooting

## Dropping to shell
Edit the docker file by removing forward from failing step, build and then drop to shell to try out the failing command manually:
`docker container run -it supertimemachine /bin/sh`


