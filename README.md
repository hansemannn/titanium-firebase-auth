# Firebase Auth - Titanium Module
Use the native Firebase SDK in Axway Titanium. This repository is part of the [Titanium Firebase](https://github.com/hansemannn/titanium-firebase) project.

## Requirements
- [x] Titanium SDK 6.2.0 or later

## Download
- [x] [Stable release](https://github.com/hansemannn/titanium-firebase-auth/releases)
- [x] [![gitTio](http://hans-knoechel.de/shields/shield-gittio.svg)](http://gitt.io/component/firebase.auth)

## API's

### `FirebaseAuth`

#### Methods (*Arguments TBA*)

##### `fetchProviders(parameters)` (Dictionary)

##### `createUserWithEmail(parameters)` (Dictionary)

##### `signInWithEmail(parameters)` (Dictionary)

##### `signInWithCredential(parameters)` (Dictionary)

##### `signInAndRetrieveDataWithCredential(parameters)` (Dictionary)

##### `signInAnonymously(parameters)` (Dictionary)

##### `signInWithCustomToken(parameters)` (Dictionary)

##### `signOut(parameters)` (Dictionary)

##### `sendPasswordResetWithEmail(parameters)` (Dictionary)

##### `confirmPasswordResetWithCode(parameters)` (Dictionary)

##### `checkActionCode(parameters)` (Dictionary)

##### `verifyPasswordResetCode(parameters)` (Dictionary)

##### `applyActionCode(parameters)` (Dictionary)

##### `addAuthStateDidChangeListener(callback)` (Function)

##### `removeAuthStateDidChangeListener()`

##### `addIDTokenDidChangeListener(callback)` (Function)

##### `removeIDTokenDidChangeListener()`

#### Properties

##### `currentUser` (Dictionary, get)

##### `languageCode` (String, get)

##### `apnsToken` (Ti.Blob, get)

## Example
```js
// Require the Firebase Auth module
var FirebaseAuth = require('firebase.auth');

FirebaseAuth.signInWithEmail({
  email: 'john@doe.com',
  password: 't1r0ck$!',
  callback: function(e) {
    if (!e.success) {
      Ti.API.error('Error: ' + e.error);
      return;
    }

    Ti.API.info('Success!');
    Ti.API.info(e.user);
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
