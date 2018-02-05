# Using elm
## Installing new dependencies
```
elm-package install elm-community/json-extra
```

# About the Webpack
Webpack has been setup following: https://github.com/elm-community/elm-webpack-starter

## Setup
Install all dependencies using the handy `reinstall` script:
```
npm run reinstall
```
*This does a clean (re)install of all npm and elm packages, plus a global elm install.*

## Serve locally:
We need to setup the url for the REST API, which is server from another
port. Also you need to configure the API to allow CORS for JavaScript 
served through Webpack (see [README](../backend/README.md)).
```
export API_URL=http://localhost:8000
npm start
```
* Access app at `http://localhost:8080/`
* Get coding! The entry point file is `src/elm/Main.elm`
* Browser will refresh automatically on any file changes.


### Build & bundle for prod:
```
npm run build
```

* Files are saved into the `/dist` folder
* To check it, open `dist/index.html`