// pull in desired CSS/SASS files
require( './styles/main.scss' );
var $ = jQuery = require( '../../node_modules/jquery/dist/jquery.js' );           // <--- remove if jQuery not needed
require( '../../node_modules/bootstrap-sass/assets/javascripts/bootstrap.js' );   // <--- remove if Bootstrap's JS not needed

var token = getUrlVar('id_token');
console.log("token from url: " + token);
console.log("token from storage: " + localStorage.getItem('id_token'))

// If not already authenticated and not authentication request redirect user for authentication
if(!localStorage.getItem('id_token') && !token) {
    console.log("No token from storage or from request. Redirecting to Coqnito.")
    window.location.href='https://supertimemachine.auth.us-east-1.amazoncognito.com/login?response_type=token&client_id=4uvrqrnjqufo0qr2h5d6vj51cm&redirect_uri=http://localhost:8080/';
} else {
    // Handle authentication request
    if(token) {
        console.log("Token from the request, setting it to local storage. Clearing token from url.")
        localStorage.setItem('id_token',token);
        window.location.href = stripParams(window.location.href);
    }

    // inject bundled Elm app into div#main
    console.log("Starting Elm...");
    var Elm = require( '../elm/Main' );
    Elm.Main.embed( document.getElementById( 'main' ) , {
        apiUrl: process.env.API_URL || '',
        token: localStorage.getItem('id_token')
    });
}

function stripParams(url) {
    return url.replace(/#.*/,'');
}

function getUrlVar(key){
	var result = new RegExp(key + "=([^&]*)", "i").exec(window.location.href);
	return result && unescape(result[1]) || null;
}