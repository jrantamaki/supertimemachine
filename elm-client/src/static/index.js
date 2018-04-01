// pull in desired CSS/SASS files
require( './styles/main.scss' );
var $ = jQuery = require( '../../node_modules/jquery/dist/jquery.js' );           // <--- remove if jQuery not needed
require( '../../node_modules/bootstrap-sass/assets/javascripts/bootstrap.js' );   // <--- remove if Bootstrap's JS not needed


// If there is no token in local storage redirect user for authentication
if(!localStorage.getItem('token')) {
   window.location.href='https://supertimemachine.auth.us-east-1.amazoncognito.com/login?response_type=token&client_id=4uvrqrnjqufo0qr2h5d6vj51cm&redirect_uri=http://localhost:8080/';
} else {
    // inject bundled Elm app into div#main
    var Elm = require( '../elm/Main' );
    Elm.Main.embed( document.getElementById( 'main' ) , {
        apiUrl: process.env.API_URL || '',
    });
}