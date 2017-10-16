/**
 * titanium-firebase-auth
 *
 * Created by Hans Knoechel
 * Copyright (c) 2017 Your Company. All rights reserved.
 */

#import "TiModule.h"

@interface FirebaseAuthModule : TiModule {
}

- (void)createUserWithEmail:(id)arguments;

- (void)signInWithEmail:(id)arguments;

- (void)signOut:(id)arguments;

- (void)sendPasswordResetWithEmail:(id)arguments;

- (NSDictionary *)currentUser;

@end
