/**
 * titanium-firebase-auth
 *
 * Created by Hans Knoechel
 * Copyright (c) 2017 Your Company. All rights reserved.
 */

#import <FirebaseAuth/FirebaseAuth.h>

#import "FirebaseAuthModule.h"
#import "FirebaseAuthUtilities.h"
#import "FirebaseAuthAuthCredentialProxy.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation FirebaseAuthModule

#pragma mark Internal

- (id)moduleGUID
{
  return @"dc98ce27-7b7c-4596-8ef2-b16715576c9a";
}

- (NSString *)moduleId
{
  return @"firebase.auth";
}

#pragma mark Lifecycle

- (void)startup
{
  [super startup];
  NSLog(@"[DEBUG] %@ loaded", self);
}

#pragma Public APIs

- (void)fetchProviders:(id)arguments
{
  ENSURE_UI_THREAD(fetchProviders, arguments);
  ENSURE_SINGLE_ARG(arguments, NSDictionary);
  
  NSString *email;
  KrollCallback *callback;

  ENSURE_ARG_FOR_KEY(email, arguments, @"email", NSString);
  ENSURE_ARG_FOR_KEY(callback, arguments, @"callback", KrollCallback);

  [[FIRAuth auth] fetchProvidersForEmail:email
                              completion:^(NSArray<NSString *> *providers, NSError *error) {
                                if (error != nil) {
                                  [callback call:@[[FirebaseAuthUtilities dictionaryFromError:error]] thisObject:self];
                                  return;
                                }

                                [callback call:@[@{ @"success": @YES, @"providers": providers ?: @[] }] thisObject:self];
                              }];
}

- (void)createUserWithEmail:(id)arguments
{
  ENSURE_UI_THREAD(createUserWithEmail, arguments);
  ENSURE_SINGLE_ARG(arguments, NSDictionary);

  NSString *email;
  NSString *password;
  KrollCallback *callback;

  ENSURE_ARG_FOR_KEY(email, arguments, @"email", NSString);
  ENSURE_ARG_FOR_KEY(password, arguments, @"password", NSString);
  ENSURE_ARG_FOR_KEY(callback, arguments, @"callback", KrollCallback);

  [[FIRAuth auth] createUserWithEmail:email
                             password:password
                           completion:^(FIRUser *_Nullable user, NSError *_Nullable error) {
                             if (error != nil) {
                               [callback call:@[[FirebaseAuthUtilities dictionaryFromError:error]] thisObject:self];
                               return;
                             }
                             
                             [callback call:@[@{ @"success": @TRUE, @"user": [FirebaseAuthUtilities dictionaryFromUser:user] }] thisObject:self];
                           }];
}

- (void)signInWithEmail:(id)arguments
{
  ENSURE_UI_THREAD(signInWithEmail, arguments);
  ENSURE_SINGLE_ARG(arguments, NSDictionary);

  NSString *email;
  NSString *password;
  KrollCallback *callback;

  ENSURE_ARG_FOR_KEY(email, arguments, @"email", NSString);
  ENSURE_ARG_FOR_KEY(password, arguments, @"password", NSString);
  ENSURE_ARG_FOR_KEY(callback, arguments, @"callback", KrollCallback);

  [[FIRAuth auth] signInWithEmail:email
                         password:password
                       completion:^(FIRUser *user, NSError *error) {
                         if (error != nil) {
                           [callback call:@[[FirebaseAuthUtilities dictionaryFromError:error]] thisObject:self];
                           return;
                         }
                         
                         [callback call:@[@{ @"success": @TRUE, @"user": [FirebaseAuthUtilities dictionaryFromUser:user] }] thisObject:self];
                       }];
}

- (void)signInWithCredential:(id)arguments
{
  ENSURE_UI_THREAD(signInWithCredential, arguments);
  ENSURE_SINGLE_ARG(arguments, NSDictionary);
  
  FirebaseAuthAuthCredentialProxy *credential;
  KrollCallback *callback;
  
  ENSURE_ARG_FOR_KEY(credential, arguments, @"credential", FirebaseAuthAuthCredentialProxy);
  ENSURE_ARG_FOR_KEY(callback, arguments, @"callback", KrollCallback);
  
  [[FIRAuth auth] signInWithCredential:[credential authCredential]
                            completion:^(FIRUser *user, NSError *error) {
                              if (error != nil) {
                                [callback call:@[[FirebaseAuthUtilities dictionaryFromError:error]] thisObject:self];
                                return;
                              }
                              
                              [callback call:@[@{ @"success": @TRUE, @"user": [FirebaseAuthUtilities dictionaryFromUser:user] }] thisObject:self];
                            }];
}

- (void)signInAndRetrieveDataWithCredential:(id)arguments
{
  ENSURE_UI_THREAD(signInAndRetrieveDataWithCredential, arguments);
  ENSURE_SINGLE_ARG(arguments, NSDictionary);
  
  FirebaseAuthAuthCredentialProxy *credential;
  KrollCallback *callback;
  
  ENSURE_ARG_FOR_KEY(credential, arguments, @"credential", FirebaseAuthAuthCredentialProxy);
  ENSURE_ARG_FOR_KEY(callback, arguments, @"callback", KrollCallback);
  
  [[FIRAuth auth] signInAndRetrieveDataWithCredential:[credential authCredential]
                                           completion:^(FIRAuthDataResult *_Nullable authResult,
                                                        NSError *_Nullable error) {
                                             if (error != nil) {
                                               [callback call:@[[FirebaseAuthUtilities dictionaryFromError:error]] thisObject:self];
                                               return;
                                             }
                              
                                             [callback call:@[@{
                                               @"success": @TRUE,
                                               @"user": [FirebaseAuthUtilities dictionaryFromUser:authResult.user],
                                               @"additionalUserInfo": [FirebaseAuthUtilities dictionaryFromAdditionalUserInfo:authResult.additionalUserInfo]
                                             }] thisObject:self];
                            }];
}

- (void)signInAnonymously:(id)callback
{
  ENSURE_UI_THREAD(signInAnonymously, callback);
  ENSURE_SINGLE_ARG(callback, KrollCallback);
  
  [[FIRAuth auth] signInAnonymouslyWithCompletion:^(FIRUser *user, NSError *error) {
    if (error != nil) {
      [callback call:@[[FirebaseAuthUtilities dictionaryFromError:error]] thisObject:self];
      return;
    }
    
    [callback call:@[@{ @"success": @TRUE, @"user": [FirebaseAuthUtilities dictionaryFromUser:user] }] thisObject:self];
  }];
}


- (void)signInWithCustomToken:(id)arguments
{
  ENSURE_UI_THREAD(signInWithCustomToken, arguments);
  ENSURE_SINGLE_ARG(arguments, NSDictionary);
  
  NSString *token;
  KrollCallback *callback;
  
  ENSURE_ARG_FOR_KEY(token, arguments, @"token", NSString);
  ENSURE_ARG_FOR_KEY(callback, arguments, @"callback", KrollCallback);
  
  [[FIRAuth auth] signInWithCustomToken:token
                             completion:^(FIRUser *user, NSError *error) {
                                             if (error != nil) {
                                               [callback call:@[[FirebaseAuthUtilities dictionaryFromError:error]] thisObject:self];
                                               return;
                                             }
                                             
                                             [callback call:@[@{
                                               @"success": @TRUE,
                                               @"user": [FirebaseAuthUtilities dictionaryFromUser:user],
                                             }] thisObject:self];
                                           }];
}

- (void)signOut:(id)arguments
{
  ENSURE_UI_THREAD(signOut, arguments);
  ENSURE_SINGLE_ARG(arguments, NSDictionary);

  KrollCallback *callback;

  ENSURE_ARG_FOR_KEY(callback, arguments, @"callback", KrollCallback);

  NSError *authError;
  BOOL success = [[FIRAuth auth] signOut:&authError]; //Note: odd signOut seems to always return true!?

  if (success && !authError) {
    // Sign-out succeeded
    [callback call:@[@{ @"success": NUMINT(YES) }] thisObject:self];
  }
  
  [callback call:@[ [FirebaseAuthUtilities dictionaryFromError:authError] ] thisObject:self];
}

- (void)sendPasswordResetWithEmail:(id)arguments
{
  ENSURE_UI_THREAD(sendPasswordResetWithEmail, arguments);
  ENSURE_SINGLE_ARG(arguments, NSDictionary);

  NSString *email;
  KrollCallback *callback;

  ENSURE_ARG_FOR_KEY(callback, arguments, @"callback", KrollCallback);
  ENSURE_ARG_FOR_KEY(email, arguments, @"email", NSString);

  [[FIRAuth auth] sendPasswordResetWithEmail:email
                                  completion:^(NSError *error) {
                                    if (error != nil) {
                                      [callback call:@[@{ @"success" : @NO }] thisObject:self];
                                      return;
                                    }
                                    
                                    [callback call:@[@{ @"success" : @YES }] thisObject:self];
                                  }];
}

- (NSDictionary *)currentUser
{
  return [FirebaseAuthUtilities dictionaryFromUser:[[FIRAuth auth] currentUser]];
}

- (NSString *)languageCode
{
  return NULL_IF_NIL([[FIRAuth auth] languageCode]);
}

- (TiBlob *)apnsToken
{
  return [[TiBlob alloc] _initWithPageContext:self.pageContext andData:[[FIRAuth auth] APNSToken] mimetype:@"text/plain"];
}

- (FirebaseAuthAuthCredentialProxy *)createAuthCredential:(id)arguments
{
  ENSURE_SINGLE_ARG(arguments, NSDictionary);
  
  TiFirebaseAuthProviderType provider = [TiUtils intValue:[arguments objectForKey:@"provider"] def:TiFirebaseAuthProviderTypeUnknown];
  NSString *accessToken = [arguments objectForKey:@"accessToken"];
  NSString *secretToken = [arguments objectForKey:@"secretToken"];
  
  return [[FirebaseAuthAuthCredentialProxy alloc] _initWithPageContext:self.pageContext
                                                   andAuthProviderType:provider
                                                           accessToken:accessToken
                                                           secretToken:secretToken];
}

MAKE_SYSTEM_PROP(AUTH_PROVIDER_TYPE_UNKNOWN, TiFirebaseAuthProviderTypeUnknown);
MAKE_SYSTEM_PROP(AUTH_PROVIDER_TYPE_FACEBOOK, TiFirebaseAuthProviderTypeFacebook);
MAKE_SYSTEM_PROP(AUTH_PROVIDER_TYPE_TWITTER, TiFirebaseAuthProviderTypeTwitter);
MAKE_SYSTEM_PROP(AUTH_PROVIDER_TYPE_GOOGLE, TiFirebaseAuthProviderTypeGoogle);
MAKE_SYSTEM_PROP(AUTH_PROVIDER_TYPE_GITHUB, TiFirebaseAuthProviderTypeGithub);
MAKE_SYSTEM_PROP(AUTH_PROVIDER_TYPE_PASSWORD, TiFirebaseAuthProviderTypePassword);
MAKE_SYSTEM_PROP(AUTH_PROVIDER_TYPE_PHONE, TiFirebaseAuthProviderTypePhone);

@end
