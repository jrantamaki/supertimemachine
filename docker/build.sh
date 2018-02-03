#!/bin/bash
echo "Webpack is not yet installed in the Docker build so we need to have elm-client built before"
cd ../elm-client
npm run reinstall
npm run build

echo "Now lets build the docker image"
cd ..
docker build -t archvile/supertimemachine .
