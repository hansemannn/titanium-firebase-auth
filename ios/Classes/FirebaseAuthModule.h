/**
 * titanium-firebase-auth
 *
 * Created by Hans Knoechel
 * Copyright (c) 2017-present Hans Knöchel. All rights reserved.
 */

#import <FirebaseAuth/FirebaseAuth.h>
#import "TiModule.h"

@interface FirebaseAuthModule : TiModule {
  id<NSObject> _authStateListenerHandle;
  id<NSObject> _IDTokenListenerHandle;
}

- (void)fetchProviders:(id)arguments;

- (void)createUserWithEmail:(id)arguments;

- (void)signInWithEmail:(id)arguments;

- (void)signInWithCredential:(id)arguments;

- (void)signInAndRetrieveDataWithCredential:(id)arguments;

- (void)signInAnonymously:(id)arguments;

- (void)signInWithCustomToken:(id)arguments;

- (void)signOut:(id)arguments;

- (void)sendPasswordResetWithEmail:(id)arguments;

- (void)confirmPasswordResetWithCode:(id)arguments;

- (void)checkActionCode:(id)arguments;

- (void)verifyPasswordResetCode:(id)arguments;

- (void)applyActionCode:(id)arguments;

- (void)addAuthStateDidChangeListener:(id)callback;

- (void)removeAuthStateDidChangeListener:(id)unused;

- (void)addIDTokenDidChangeListener:(id)callback;

- (void)removeIDTokenDidChangeListener:(id)unused;

- (NSDictionary *)currentUser;

- (NSString *)languageCode;

- (TiBlob *)apnsToken;

@end
