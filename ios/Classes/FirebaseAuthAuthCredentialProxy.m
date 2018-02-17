/**
 * titanium-firebase-auth
 *
 * Created by Hans Knoechel
 * Copyright (c) 2017 Axway Appcelerator. All rights reserved.
 */

#import "FirebaseAuthAuthCredentialProxy.h"

@implementation FirebaseAuthAuthCredentialProxy

- (id)_initWithPageContext:(id<TiEvaluator>)context
           andAuthProviderType:(TiFirebaseAuthProviderType)authProviderType
               accessToken:(NSString *)accessToken
               secretToken:(NSString *)secretToken
                providerID:(NSString *)providerID
                IDToken:(NSString *)IDToken
{
  if (self = [super _initWithPageContext:context]) {
    switch (authProviderType) {
      case TiFirebaseAuthProviderTypeFacebook:
        _authCredential = [FIRFacebookAuthProvider credentialWithAccessToken:accessToken];
      break;
      case TiFirebaseAuthProviderTypeTwitter:
        _authCredential = [FIRTwitterAuthProvider credentialWithToken:accessToken secret:secretToken];
      break;
      case TiFirebaseAuthProviderTypeGoogle:
        _authCredential = [FIRGoogleAuthProvider credentialWithIDToken:accessToken accessToken:secretToken];
      break;
      case TiFirebaseAuthProviderTypeGithub:
        _authCredential = [FIRGitHubAuthProvider credentialWithToken:accessToken];
      break;
      case TiFirebaseAuthProviderTypePassword:
        _authCredential = [FIREmailAuthProvider credentialWithEmail:accessToken password:secretToken];
      break;
      case TiFirebaseAuthProviderTypePhone:
        _authCredential = [[FIRPhoneAuthProvider provider] credentialWithVerificationID:accessToken
                                                                       verificationCode:secretToken];
      break;
      case TiFirebaseAuthProviderTypeOAuth: {
        if (IDToken == nil) {
          _authCredential = [FIROAuthProvider credentialWithProviderID:providerID accessToken:accessToken];
        } else {
          _authCredential = [FIROAuthProvider credentialWithProviderID:providerID
                                                               IDToken:IDToken
                                                           accessToken:accessToken];
        }
      }
      break;
      default:
        NSLog(@"[ERROR] Unknown auth-provider-type provided: %lu", authProviderType);
    }
  }
  
  return self;
}

@end
