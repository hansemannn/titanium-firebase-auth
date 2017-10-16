// Require the Firebase Storage module
var FirebaseAuth = require('firebase.auth');

FirebaseAuth.signInWithEmail({
	email: 'john@doe.com',
	password: 'T1t4n1umR0ck$***',
	success: function(e) {
		alert('Logged in!');
	},
	error: function(e) {
		Ti.API.error('Error logging in: ' + e.error);
	}
})

// TODO: Write more examples based from the Readme.
