#!/bin/bash
echo 'Building Elm client'

# exit when any command fails
set -e

npm install
npm run build

