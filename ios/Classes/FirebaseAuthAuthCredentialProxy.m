/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2017 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "FirebaseAuthAuthCredentialProxy.h"

@implementation FirebaseAuthAuthCredentialProxy

- (id)_initWithPageContext:(id<TiEvaluator>)context
           andAuthProviderType:(TiFirebaseAuthProviderType)authProviderType
               accessToken:(NSString *)accessToken
               secretToken:(NSString *)secretToken
{
  if (self = [super _initWithPageContext:context]) {
    switch (authProviderType) {
      case TiFirebaseAuthProviderTypeFacebook:
        _authCredential = [FIRFacebookAuthProvider credentialWithAccessToken:accessToken];
      case TiFirebaseAuthProviderTypeTwitter:
        _authCredential = [FIRTwitterAuthProvider credentialWithToken:accessToken secret:secretToken];
      case TiFirebaseAuthProviderTypeGoogle:
        _authCredential = [FIRGoogleAuthProvider credentialWithIDToken:accessToken accessToken:secretToken];
      case TiFirebaseAuthProviderTypeGithub:
        _authCredential = [FIRGitHubAuthProvider credentialWithToken:accessToken];
      case TiFirebaseAuthProviderTypePassword:
        _authCredential = [FIREmailAuthProvider credentialWithEmail:accessToken password:secretToken];
      case TiFirebaseAuthProviderTypePhone:
        _authCredential = [[FIRPhoneAuthProvider provider] credentialWithVerificationID:accessToken verificationCode:secretToken];
      default:
        NSLog(@"[ERROR] Unknown auth-provider-type provided: %lu", authProviderType);
    }
  }
  
  return self;
}

@end
