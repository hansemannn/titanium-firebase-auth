/**
 * titanium-firebase-auth
 *
 * Created by Hans Knoechel
 * Copyright (c) 2017 Your Company. All rights reserved.
 */

#import "TiModule.h"

@interface FirebaseAuthModule : TiModule {
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

- (NSDictionary *)currentUser;

- (NSString *)languageCode;

- (TiBlob *)apnsToken;

@end
