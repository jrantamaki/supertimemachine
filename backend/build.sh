#!/bin/bash
export GOPATH=$PWD
cd src
govendor sync
cd supertimemachine
go build -o ../../goapp
cd $GOPATH
