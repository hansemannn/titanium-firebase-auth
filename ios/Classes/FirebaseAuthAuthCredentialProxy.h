/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2017 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
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
