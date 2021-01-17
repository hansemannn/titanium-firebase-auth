# Firebase Auth - Titanium Module
Use the native Firebase SDK in Axway Titanium. This repository is part of the [Titanium Firebase](https://github.com/hansemannn/titanium-firebase) project.

## Supporting this effort

The whole Firebase support in Titanium is developed and maintained by the community (`@hansemannn` and `@m1ga`). To keep
this project maintained and be able to use the latest Firebase SDK's, please see the "Sponsor" button of this repository,
thank you!

## Requirements
- [x] The [Firebase Core](https://github.com/hansemannn/titanium-firebase-core) module
- [x] iOS: Titanium SDK 6.3.0+
- [x] Android: Titanium SDK 7.0.0+ / Titanium SDK 9.0.0+ for Version 3.0.0+

## ToDo's
- Expose all iOS API's to Android

## Download
- [x] [Stable release](https://github.com/hansemannn/titanium-firebase-auth/releases)
- [x] [![gitTio](http://hans-knoechel.de/shields/shield-gittio.svg)](http://gitt.io/component/firebase.auth)

## API's

### `FirebaseAuth`

#### Methods (*Arguments TBA*)

##### `fetchProviders(parameters)` (Dictionary)

##### `createUserWithEmail(parameters)` (Dictionary)

##### `signInWithEmail(parameters)` (Dictionary)

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

// More TBA
```

## Build
```js
cd ios
appc ti build -p ios --build-only
```

## Legal

This module is Copyright (c) 2017-Present by Appcelerator, Inc. All Rights Reserved.
Usage of this module is subject to the Terms of Service agreement with Appcelerator, Inc.  
