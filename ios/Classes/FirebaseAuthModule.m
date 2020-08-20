/**
 * titanium-firebase-auth
 *
 * Created by Hans Knoechel
 * Copyright (c) 2017-present Hans Knöchel. All rights reserved.
 */

#import "FirebaseAuthModule.h"
#import "FirebaseAuthUtilities.h"
#import "FirebaseAuthAuthCredentialProxy.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiBlob.h"
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

  [[FIRAuth auth] fetchSignInMethodsForEmail:email
                                  completion:^(NSArray<NSString *> * _Nullable providers, NSError * _Nullable error) {
    if (error != nil) {
      [callback call:@[[FirebaseAuthUtilities dictionaryFromError:error]] thisObject:self];
      return;
    }

    [callback call:@[@{ @"success": @(YES), @"providers": providers ?: @[] }] thisObject:self];
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

  [[FIRAuth auth] createUserWithEmail:email password:password completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
    if (error != nil) {
     [callback call:@[[FirebaseAuthUtilities dictionaryFromError:error]] thisObject:self];
     return;
    }

    [authResult.user getIDTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
      [callback call:@[@{
        @"success": @(YES),
        @"token": NULL_IF_NIL(token),
        @"refreshToken": NULL_IF_NIL(authResult.user.refreshToken),
        @"user": [FirebaseAuthUtilities dictionaryFromUser:authResult.user]
      }] thisObject:self];
    }];
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

  [[FIRAuth auth] signInWithEmail:email password:password completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
    if (error != nil) {
      [callback call:@[[FirebaseAuthUtilities dictionaryFromError:error]] thisObject:self];
      return;
    }

    [authResult.user getIDTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
      [callback call:@[@{
        @"success": @(YES),
        @"token": NULL_IF_NIL(token),
        @"refreshToken": NULL_IF_NIL(authResult.user.refreshToken),
        @"user": [FirebaseAuthUtilities dictionaryFromUser:authResult.user]
      }] thisObject:self];
    }];
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
                            completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
                              if (error != nil) {
                                [callback call:@[[FirebaseAuthUtilities dictionaryFromError:error]] thisObject:self];
                                return;
                              }
                              
                              [callback call:@[@{ @"success": @(YES), @"user": [FirebaseAuthUtilities dictionaryFromUser:authResult.user] }] thisObject:self];
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
  
  [[FIRAuth auth] signInWithCredential:credential.authCredential completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
   if (error != nil) {
     [callback call:@[[FirebaseAuthUtilities dictionaryFromError:error]] thisObject:self];
     return;
   }

   [callback call:@[@{
     @"success": @(YES),
     @"user": [FirebaseAuthUtilities dictionaryFromUser:authResult.user],
     @"additionalUserInfo": [FirebaseAuthUtilities dictionaryFromAdditionalUserInfo:authResult.additionalUserInfo]
   }] thisObject:self];
  }];
}

- (void)signInAnonymously:(id)callback
{
  ENSURE_UI_THREAD(signInAnonymously, callback);
  ENSURE_SINGLE_ARG(callback, KrollCallback);
  
  [[FIRAuth auth] signInAnonymouslyWithCompletion:^(FIRAuthDataResult *_Nullable authResult, NSError *error) {
    if (error != nil) {
      [callback call:@[[FirebaseAuthUtilities dictionaryFromError:error]] thisObject:self];
      return;
    }
    
    [callback call:@[@{ @"success": @(YES), @"user": [FirebaseAuthUtilities dictionaryFromUser:authResult.user] }] thisObject:self];
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
                             completion:^(FIRAuthDataResult *_Nullable authResult, NSError *error) {
                                             if (error != nil) {
                                               [callback call:@[[FirebaseAuthUtilities dictionaryFromError:error]] thisObject:self];
                                               return;
                                             }
                                             
                                             [callback call:@[@{
                                               @"success": @(YES),
                                               @"user": [FirebaseAuthUtilities dictionaryFromUser:authResult.user],
                                             }] thisObject:self];
                                           }];
}

- (void)signOut:(id)callback
{
  ENSURE_UI_THREAD(signOut, callback);
  ENSURE_SINGLE_ARG_OR_NIL(callback, KrollCallback);
  
  NSError *authError;
  BOOL success = [[FIRAuth auth] signOut:&authError]; //Note: odd signOut seems to always return true!?

  if (callback == nil) { return; }

  if (success && !authError) {
    // Sign-out succeeded
    [callback call:@[@{ @"success": NUMINT(YES) }] thisObject:self];
    return;
  }
  
  [callback call:@[ [FirebaseAuthUtilities dictionaryFromError:authError] ] thisObject:self];
}

- (void)deleteUser:(id)callback
{
  ENSURE_SINGLE_ARG(callback, KrollCallback);

  if ([[FIRAuth auth] currentUser] == nil) {
    [callback call:@[@{ @"success": @(NO), @"error": @"No such user" }] thisObject:self];
    return;
  }

  [[[FIRAuth auth] currentUser] deleteWithCompletion:^(NSError * _Nullable error) {
    if (error != nil) {
      [callback call:@[@{ @"success": @(NO), @"error": error.localizedDescription }] thisObject:self];
      return;
    }
    [callback call:@[@{ @"success": @(YES) }] thisObject:self];
    }];
}

- (void)sendPasswordResetWithEmail:(id)arguments
{
  ENSURE_UI_THREAD(sendPasswordResetWithEmail, arguments);
  ENSURE_SINGLE_ARG(arguments, NSDictionary);
  
  NSString *email;
  KrollCallback *callback;
  NSDictionary *actionCodeSettings;
  
  ENSURE_ARG_FOR_KEY(email, arguments, @"email", NSString);
  ENSURE_ARG_OR_NIL_FOR_KEY(actionCodeSettings, arguments, @"actionCodeSettings", NSDictionary);
  ENSURE_ARG_FOR_KEY(callback, arguments, @"callback", KrollCallback);
  
  typedef void (^PasswordResetCompletionHandler)(NSError *);

  PasswordResetCompletionHandler handler = ^(NSError *error) {
    if (error != nil) {
      [callback call:@[@{ @"success" : @NO }] thisObject:self];
      return;
    }
    
    [callback call:@[@{ @"success" : @(YES) }] thisObject:self];
  };
  
  if (actionCodeSettings != nil) {
    [[FIRAuth auth] sendPasswordResetWithEmail:email
                            actionCodeSettings:[FirebaseAuthUtilities actionCodeSettingsFromDictionary:actionCodeSettings]
                                    completion:handler];
    return;
  }
  
  [[FIRAuth auth] sendPasswordResetWithEmail:email
                                  completion:handler];
}

- (void)confirmPasswordResetWithCode:(id)arguments
{
  ENSURE_UI_THREAD(confirmPasswordResetWithCode, arguments);
  ENSURE_SINGLE_ARG(arguments, NSDictionary);
  
  NSString *code;
  NSString *newPassword;
  KrollCallback *callback;
  
  ENSURE_ARG_FOR_KEY(code, arguments, @"code", NSString);
  ENSURE_ARG_FOR_KEY(newPassword, arguments, @"newPassword", NSString);
  ENSURE_ARG_FOR_KEY(callback, arguments, @"callback", KrollCallback);
  
  [[FIRAuth auth] confirmPasswordResetWithCode:code
                                   newPassword:newPassword
                                    completion:^(NSError *error) {
                                    if (error != nil) {
                                      [callback call:@[@{ @"success" : @NO }] thisObject:self];
                                      return;
                                    }
                                    
                                    [callback call:@[@{ @"success" : @(YES) }] thisObject:self];
                                  }];
}

- (void)checkActionCode:(id)arguments
{
  ENSURE_UI_THREAD(checkActionCode, arguments);
  ENSURE_SINGLE_ARG(arguments, NSDictionary);
  
  NSString *code;
  KrollCallback *callback;
  
  ENSURE_ARG_FOR_KEY(code, arguments, @"code", NSString);
  ENSURE_ARG_FOR_KEY(callback, arguments, @"callback", KrollCallback);
  
  [[FIRAuth auth] checkActionCode:code
                       completion:^(FIRActionCodeInfo *info, NSError *error) {
                         if (error != nil) {
                           [callback call:@[@{ @"success" : @NO }] thisObject:self];
                           return;
                         }
                         [callback call:@[@{ @"success" : @(YES), @"operation": @(info.operation) }] thisObject:self];
                       }];
}

- (void)verifyPasswordResetCode:(id)arguments
{
  ENSURE_UI_THREAD(verifyPasswordResetCode, arguments);
  ENSURE_SINGLE_ARG(arguments, NSDictionary);
  
  NSString *code;
  KrollCallback *callback;
  
  ENSURE_ARG_FOR_KEY(code, arguments, @"code", NSString);
  ENSURE_ARG_FOR_KEY(callback, arguments, @"callback", KrollCallback);
  
  [[FIRAuth auth] verifyPasswordResetCode:code
                               completion:^(NSString *email, NSError *error) {
                                 if (error != nil) {
                                   [callback call:@[@{ @"success" : @NO }] thisObject:self];
                                   return;
                                 }
                                 
                                 [callback call:@[@{ @"success" : @(YES), @"email": email }] thisObject:self];
                               }];
}

- (void)applyActionCode:(id)arguments
{
  ENSURE_UI_THREAD(applyActionCode, arguments);
  ENSURE_SINGLE_ARG(arguments, NSDictionary);
  
  NSString *code;
  KrollCallback *callback;
  
  ENSURE_ARG_FOR_KEY(code, arguments, @"code", NSString);
  ENSURE_ARG_FOR_KEY(callback, arguments, @"callback", KrollCallback);
  
  [[FIRAuth auth] applyActionCode:code
                       completion:^(NSError *error) {
                         if (error != nil) {
                           [callback call:@[@{ @"success" : @NO }] thisObject:self];
                           return;
                         }
                         
                         [callback call:@[@{ @"success" : @(YES) }] thisObject:self];
                       }];
}

- (void)addAuthStateDidChangeListener:(id)callback
{
  ENSURE_UI_THREAD(addAuthStateDidChangeListener, callback);
  ENSURE_SINGLE_ARG(callback, KrollCallback);
  
  if (_authStateListenerHandle != nil) {
    NSLog(@"[ERROR] Trying to add an auth-state-listener, but there is already an existing one! Call `removeAuthStateDidChangeListener` before.");
  }
  
  _authStateListenerHandle = [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth *auth, FIRUser *user) {
    if (user != nil) {
      [callback call:@[@{ @"success": @NO }] thisObject:self];
      return;
    }
    
    [callback call:@[@{ @"success": @(YES), @"user": [FirebaseAuthUtilities dictionaryFromUser:user] }] thisObject:self];
  }];
}

- (void)removeAuthStateDidChangeListener:(id)unused
{
  ENSURE_UI_THREAD(removeAuthStateDidChangeListener, unused);
  
  if (_authStateListenerHandle == nil) {
    NSLog(@"[ERROR] Trying to remove an auth-state-listener, but there is no existing one! Call `addAuthStateDidChangeListener` before.");
  }
  
  [[FIRAuth auth] removeAuthStateDidChangeListener:_authStateListenerHandle];
  _authStateListenerHandle = nil;
}

- (void)addIDTokenDidChangeListener:(id)callback
{
  ENSURE_UI_THREAD(addAuthStateDidChangeListener, callback);
  ENSURE_SINGLE_ARG(callback, KrollCallback);
  
  if (_IDTokenListenerHandle != nil) {
    NSLog(@"[ERROR] Trying to add an auth-state-listener, but there is already an existing one! Call `removeIDTokenDidChangeListener` before.");
  }
  
  _IDTokenListenerHandle = [[FIRAuth auth] addIDTokenDidChangeListener:^(FIRAuth *auth, FIRUser *user) {
    if (user != nil) {
      [callback call:@[@{ @"success": @NO }] thisObject:self];
      return;
    }
    
    [callback call:@[@{ @"success": @(YES), @"user": [FirebaseAuthUtilities dictionaryFromUser:user] }] thisObject:self];
  }];
}

- (void)removeIDTokenDidChangeListener:(id)unused
{
  ENSURE_UI_THREAD(removeAuthStateDidChangeListener, unused);
  
  if (_IDTokenListenerHandle == nil) {
    NSLog(@"[ERROR] Trying to remove an ID-token-listener, but there is no existing one! Call `addIDTokenDidChangeListener` before.");
  }
  
  [[FIRAuth auth] removeAuthStateDidChangeListener:_IDTokenListenerHandle];
  _IDTokenListenerHandle = nil;
}

- (void)useAppLanguage:(id)unused
{
  [[FIRAuth auth] useAppLanguage];
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
  return [[TiBlob alloc] initWithData:[[FIRAuth auth] APNSToken] mimetype:@"text/plain"];
}

- (void)fetchIDToken:(id)args
{
  ENSURE_ARG_COUNT(args, 2);
  
  BOOL forceRefresh = [TiUtils boolValue:args[0]];
  KrollCallback *callback = args[1];

  FIRUser *currentUser = [[FIRAuth auth] currentUser];

  if (currentUser == nil) {
    [callback call:@[@{ @"success": @(NO) }] thisObject:self];
    return;
  }

  [currentUser getIDTokenForcingRefresh:forceRefresh completion:^(NSString * _Nullable token, NSError * _Nullable error) {
    if (token == nil) {
      [callback call:@[@{ @"success": @(NO) }] thisObject:self];
      return;
    }

    [callback call:@[@{ @"success": @(YES), @"token": token, @"refreshToken": NULL_IF_NIL(currentUser.refreshToken) }] thisObject:self];
  }];
}

- (FirebaseAuthAuthCredentialProxy *)createAuthCredential:(id)arguments
{
  ENSURE_SINGLE_ARG(arguments, NSDictionary);
  
  TiFirebaseAuthProviderType provider = [TiUtils intValue:[arguments objectForKey:@"provider"] def:TiFirebaseAuthProviderTypeUnknown];
  NSString *accessToken = [arguments objectForKey:@"accessToken"];
  NSString *secretToken = [arguments objectForKey:@"secretToken"];
  NSString *providerID = [arguments objectForKey:@"providerID"];
  NSString *IDToken = [arguments objectForKey:@"IDToken"];

  return [[FirebaseAuthAuthCredentialProxy alloc] _initWithPageContext:self.pageContext
                                                   andAuthProviderType:provider
                                                           accessToken:accessToken
                                                           secretToken:secretToken
                                                            providerID:providerID
                                                               IDToken:IDToken];
}

MAKE_SYSTEM_PROP(AUTH_PROVIDER_TYPE_UNKNOWN, TiFirebaseAuthProviderTypeUnknown);
MAKE_SYSTEM_PROP(AUTH_PROVIDER_TYPE_FACEBOOK, TiFirebaseAuthProviderTypeFacebook);
MAKE_SYSTEM_PROP(AUTH_PROVIDER_TYPE_TWITTER, TiFirebaseAuthProviderTypeTwitter);
MAKE_SYSTEM_PROP(AUTH_PROVIDER_TYPE_GOOGLE, TiFirebaseAuthProviderTypeGoogle);
MAKE_SYSTEM_PROP(AUTH_PROVIDER_TYPE_GITHUB, TiFirebaseAuthProviderTypeGithub);
MAKE_SYSTEM_PROP(AUTH_PROVIDER_TYPE_PASSWORD, TiFirebaseAuthProviderTypePassword);
MAKE_SYSTEM_PROP(AUTH_PROVIDER_TYPE_PHONE, TiFirebaseAuthProviderTypePhone);
MAKE_SYSTEM_PROP(AUTH_PROVIDER_TYPE_OAUTH, TiFirebaseAuthProviderTypeOAuth);

@end

