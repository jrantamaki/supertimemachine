#!/bin/bash

# exit when any command fails
set -e

echo 'Verify Go version to be: ' $GO_VERSION
go version | grep $GO_VERSION 

export GOPATH=$PWD
go get -v -u github.com/kardianos/govendor

export PATH=$PATH:$GOPATH/bin


echo 'Govendor syncing...'
cd src
govendor sync

echo 'Building GO app'
cd supertimemachine
go build -o ../../stmApp
cd $GOPATH
