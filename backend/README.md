# Setting up project Go setup

## Install Govendor
This will install Govendor to your local Go path (e.g. ~/go). 
We want it there instead of our project folder, so we first clear the 
GOPATH env variable.
```
export GOPATH=
go get -u github.com/kardianos/govendor
```

Now Govendor should be installed to your local Go path. Lets add it to 
PATH (you probably want to make this export permanent).
```
export PATH=$PATH:~/go/bin
```

## Set up GOPATH
Set GOPATH to point to the go backend project directory. You probably 
want to make this export permanent.

```
 cd backend
 export GOPATH=$PWD
```


# Managing Go dependencies

## Registering a new dependency
Dependencies are managed by Govendor. To add new dependency run:
```
cd $GOPATH/src
govendor fetch github.com/gin-contrib/cors
```
This will install dependency to $GOPATH/src/vendor/ and update the vendor.json

## Installing dependencies
Dependencies in $GOPATH/src/vendor/ are ignored from version control, so
when doing a fresh clone from repository you need to fetch all dependencies.
```
cd $GOPATH/src
govendor sync
``` 


## Running with MongoDb 

You need a mongodb instance in the mongolab or locally. Add user and collection for the database.

At the moment there is assumption that the database name is "supertimemachine-dev" and it includes a collections: "tasks"

Set the environment variables:
```
export MONGO_URL=ds123456.mlab.com:123456
export MONGO_USER=stmuser
export MONGO_PASSWORD=topsecretpassword
export MONGO_DB=supertimemachine-dev
```


