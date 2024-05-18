# Firebase Auth - Titanium Module
Use the native Firebase SDK in Axway Titanium. This repository is part of the [Titanium Firebase](https://github.com/hansemannn/titanium-firebase) project.

## Supporting this effort

The whole Firebase support in Titanium is developed and maintained by the community (`@hansemannn` and `@m1ga`). To keep
this project maintained and be able to use the latest Firebase SDK's, please see the "Sponsor" button of this repository,
thank you!

## Requirements
- [x] The [Firebase Core](https://github.com/hansemannn/titanium-firebase-core) module (iOS only)
- [x] iOS: Titanium SDK 10.0.0+
- [x] Android: Titanium SDK 9.0.0+

## Download
- [x] [Stable release](https://github.com/hansemannn/titanium-firebase-auth/releases)
- [x] [![gitTio](http://hans-knoechel.de/shields/shield-gittio.svg)](http://gitt.io/component/firebase.auth)

## API's

### `FirebaseAuth`

#### Methods (*Arguments TBA*)

##### `fetchProviders(parameters)` (Dictionary)

##### `createUserWithEmail(parameters)` (Dictionary)

##### `signInWithEmail(parameters)` (Dictionary)

##### `signInWithGoogle({idToken[string], success[function], error[function]})` (Android-only)

##### `signOut(parameters)` (Dictionary)

##### `signInWithCredential(parameters)` (Dictionary)

##### `createCredential(parameters)` (Dictionary)

##### `signInAnonymously(parameters)` (Dictionary)

##### `signInWithCustomToken(parameters)`

##### `signInAndRetrieveDataWithCredential(parameters)` (Dictionary, iOS-only)

##### `sendPasswordResetWithEmail(parameters)` (Dictionary)

##### `confirmPasswordResetWithCode(parameters)` (Dictionary, iOS-only)

##### `checkActionCode(parameters)` (Dictionary)

##### `verifyPasswordResetCode(parameters)` (Dictionary, iOS-only)

##### `applyActionCode(parameters)` (Dictionary, iOS-only)

##### `addAuthStateDidChangeListener(callback)` (Function, iOS-only)

##### `removeAuthStateDidChangeListener()`  (iOS-only)

##### `addIDTokenDidChangeListener(callback)` (Function, iOS-only)

##### `removeIDTokenDidChangeListener()` (iOS-only)

##### `fetchIDToken(forceRefresh, callback)` (Boolean, Function, Android-only)

#### Properties

##### `currentUser` (Dictionary, get)

##### `languageCode` (String, get)

##### `apnsToken` (Ti.Blob, get, iOS-only)

- For Android, use `fetchIDToken(forceRefresh, callback)`

### FirebaseAuth.AuthCredential

Virtual Type to be used in `signInWithCredential`. Create with `createCredential(parameters)`.

## Example
```js
// Require the Firebase Auth module
var FirebaseAuth = require('firebase.auth');


// Sign-up
FirebaseAuth.createUserWithEmail({
	email: 'john@doe.com',
	password: 't1r0ck$!',
	callback: function(e) {
		if (!e.success) {
			Ti.API.error('Create: error: ' + JSON.stringify(e));
			return;
		}

		Ti.API.info('Create: success!');
		Ti.API.info(JSON.stringify(e.user));
	}
});


// Login
FirebaseAuth.signInWithEmail({
  email: 'john@doe.com',
  password: 't1r0ck$!',
  callback: function(e) {
    if (!e.success) {
      Ti.API.error('Error: ' + JSON.stringify(e));
      return;
    }

    Ti.API.info('Success!');
    Ti.API.info(JSON.stringify(e.user));	// e.g.  {"uid":"...","photoURL":null,"phoneNumber":null,"email":"...","providerID":"...","displayName":null}

  }
});
```

## Sign-in with Google (Android only)

You can use this module in combination with [titanium-google-signin](https://github.com/hansemannn/titanium-google-signin). Implement the `signIn()` methods from `titanium-google-signin` and use the returned `user.authentication.idToken` to call FirebaseAuth.signInWithGoogle({idToken}). An example code would look like this:

```js
import GoogleSignIn from 'ti.googlesignin';
import FirebaseAuth from 'firebase.auth';

GoogleSignIn.initialize({
	clientID: 'your-client-id',
});

GoogleSignIn.signIn();

GoogleSignIn.addEventListener("login", function(opt) {
	let idToken = opt.user.authentication.idToken;
	if (idToken != "" && idToken != undefined) {
		FirebaseAuth.signInWithGoogle({
			idToken: idToken,
			callback: function(e) {
				if (e.success) {
					alert('Logged in!');
				} else {
				Ti.API.error('Error logging in: ' + e.error);
				}
			}
		})
	}
})

```

## Build
```js
cd ios
appc ti build -p ios --build-only
```

## Legal

This module is Copyright (c) 2017-Present by Appcelerator, Inc. All Rights Reserved.
Usage of this module is subject to the Terms of Service agreement with Appcelerator, Inc.  
