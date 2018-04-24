# Firebase Auth - Titanium Module
Use the native Firebase SDK in Axway Titanium. This repository is part of the [Titanium Firebase](https://github.com/hansemannn/titanium-firebase) project.

## Requirements
- [x] The [Firebase Core](https://github.com/hansemannn/titanium-firebase-core) module
- [x] iOS: Titanium SDK 6.3.0+
- [x] Android: Titanium SDK 7.0.0+

## ⚠️ Android Note

The Android version of this module is currently in development and should not be used in production so far!

## ToDo's
- Android: Remove `firebase-common-11.0.4.aar` and `play-services-tasks-11.0.4.aar` from the build after building because they are part of `Ti.PlayServices` and `Titanium-Firebase-Core` already and will likely cause duplicate depencency errors!
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

##### `signInAndRetrieveDataWithCredential(parameters)` (Dictionary, iOS-only)

##### `signInWithCustomToken(parameters)` (Dictionary, iOS-only)

##### `sendPasswordResetWithEmail(parameters)` (Dictionary, iOS-only)

##### `confirmPasswordResetWithCode(parameters)` (Dictionary, iOS-only)

##### `checkActionCode(parameters)` (Dictionary, iOS-only)

##### `verifyPasswordResetCode(parameters)` (Dictionary, iOS-only)

##### `applyActionCode(parameters)` (Dictionary, iOS-only)

##### `addAuthStateDidChangeListener(callback)` (Function, iOS-only)

##### `removeAuthStateDidChangeListener()`  (iOS-only)

##### `addIDTokenDidChangeListener(callback)` (Function, iOS-only)

##### `removeIDTokenDidChangeListener()` (iOS-only)

##### `fetchIDToken(forceRefresh, callback)` (Boolean, Function, Android-only)

#### Properties

##### `currentUser` (Dictionary, get)

##### `languageCode` (String, get, iOS-only)

##### `apnsToken` (Ti.Blob, get, iOS-only)

- For Android, use `fetchIDToken(forceRefresh, callback)`

### FirebaseAuth.AuthCredential

Virtual Type to be used in ``signInWithCredential`. Create with `createCredential(parameters)`.

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
