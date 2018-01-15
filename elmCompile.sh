#!/bin/bash

indent() {
  sed -u 's/^/       /'
}

echo "Running Elm make on Heroku"
cd elm-client
elm package install --yes | indent
elm-make Main.elm --output ../static/index.html | indent
cd ..
echo "Elm make done"
