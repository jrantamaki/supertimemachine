#!/bin/bash
export GOPATH=$PWD
go get github.com/gin-gonic/gin
go build -o goapp
