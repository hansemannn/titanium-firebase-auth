/**
 * titanium-firebase-auth
 *
 * Created by Hans Knoechel
 * Copyright (c) 2017-present Hans Knöchel. All rights reserved.
 */

#import "TiProxy.h"

#import <FirebaseAuth/FirebaseAuth.h>

typedef enum TiFirebaseAuthProviderType: NSUInteger {
  TiFirebaseAuthProviderTypeUnknown = 0,
  TiFirebaseAuthProviderTypeFacebook,
  TiFirebaseAuthProviderTypeTwitter,
  TiFirebaseAuthProviderTypeGoogle,
  TiFirebaseAuthProviderTypeGithub,
  TiFirebaseAuthProviderTypePassword,
  TiFirebaseAuthProviderTypePhone,
  TiFirebaseAuthProviderTypeOAuth,
} TiFirebaseAuthProviderType;

@interface FirebaseAuthAuthCredentialProxy : TiProxy {
}

@property (nonatomic, strong) FIRAuthCredential *authCredential;

- (id)_initWithPageContext:(id<TiEvaluator>)context
       andAuthProviderType:(TiFirebaseAuthProviderType)authProviderType
               accessToken:(NSString *)accessToken
               secretToken:(NSString *)secretToken
                providerID:(NSString *)providerID
                   IDToken:(NSString *)IDToken;

- (instancetype)init NS_UNAVAILABLE;

@end
