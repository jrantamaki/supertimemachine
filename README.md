
# SuperTimeMachine App

This is based on the [Getting Started with Go on Heroku](https://devcenter.heroku.com/articles/getting-started-with-go) article - check it out.

## Running Locally

Make sure you have [Go](http://golang.org/doc/install) and the [Heroku Toolbelt](https://toolbelt.heroku.com/) installed.

```sh
$ go get -u github.com/heroku/go-getting-started
$ cd $GOPATH/src/github.com/heroku/go-getting-started
$ heroku local
```

Your app should now be running on [localhost:5000](http://localhost:5000/).

You should also install [Godep](https://github.com/tools/godep) if you are going to add any dependencies to the sample app.

## Deploying to Heroku

```sh
$ heroku create
$ git push heroku master
$ heroku open
```

or

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)


## Documentation

For more information about using Go on Heroku, see these Dev Center articles:

- [Go on Heroku](https://devcenter.heroku.com/categories/go)


## Running the Elm client in development mode
- Install Elm
- Run "elm-reactor" and select the "/elm-client/Main.elm"

## Building the Elm client
- Run "elm-make elm-client/Main.elm --output static/index.html"


# Docker

## Building docker image
docker build -t archvile/supertimemachine .

## Dropping to shell
docker container run -it archvile/supertimemachine /bin/sh

## Running the app in the container
docker container run -it -p 8000:8000 --env PORT=8000 archvile/supertimemachine

## Pushing to Heroku

```sh
$ heroku container:login
$ heroku create
$ heroku container:push web
$ heroku apps:info
```