/**
 * titanium-firebase-auth
 *
 * Created by Hans Knoechel
 * Copyright (c) 2017 Your Company. All rights reserved.
 */

#import <FirebaseAuth/FirebaseAuth.h>

#import "FirebaseAuthModule.h"
#import "FirebaseAuthUtilities.h"
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

- (void)createUserWithEmail:(id)arguments
{
  ENSURE_UI_THREAD(createUserWithEmail, arguments);
  ENSURE_SINGLE_ARG(arguments, NSDictionary);

  NSString *email;
  NSString *password;
  KrollCallback *successCallback;
  KrollCallback *errorCallback;

  ENSURE_ARG_OR_NIL_FOR_KEY(email, arguments, @"email", NSString);
  ENSURE_ARG_OR_NIL_FOR_KEY(password, arguments, @"password", NSString);
  ENSURE_ARG_OR_NIL_FOR_KEY(successCallback, arguments, @"success", KrollCallback);
  ENSURE_ARG_OR_NIL_FOR_KEY(errorCallback, arguments, @"error", KrollCallback);

  [[FIRAuth auth] createUserWithEmail:email
                             password:password
                           completion:^(FIRUser *_Nullable user, NSError *_Nullable error) {
                             if (errorCallback != nil && error != nil) {
                               [errorCallback call:@[ [FirebaseAuthUtilities dictionaryFromError:error] ] thisObject:nil];
                             } else if (successCallback != nil) {
                               [successCallback call:@[ [FirebaseAuthUtilities dictionaryFromUser:user] ] thisObject:nil];
                             }
                           }];
}

- (void)signInWithEmail:(id)arguments
{
  ENSURE_UI_THREAD(signInWithEmail, arguments);
  ENSURE_SINGLE_ARG(arguments, NSDictionary);

  NSString *email;
  NSString *password;
  KrollCallback *successCallback;
  KrollCallback *errorCallback;

  ENSURE_ARG_OR_NIL_FOR_KEY(email, arguments, @"email", NSString);
  ENSURE_ARG_OR_NIL_FOR_KEY(password, arguments, @"password", NSString);
  ENSURE_ARG_OR_NIL_FOR_KEY(successCallback, arguments, @"success", KrollCallback);
  ENSURE_ARG_OR_NIL_FOR_KEY(errorCallback, arguments, @"error", KrollCallback);

  [[FIRAuth auth] signInWithEmail:email
                         password:password
                       completion:^(FIRUser *user, NSError *error) {
                         if (errorCallback != nil && error != nil) {
                           [errorCallback call:@[ [FirebaseAuthUtilities dictionaryFromError:error] ] thisObject:nil];
                         } else if (successCallback != nil) {
                           [successCallback call:@[ [FirebaseAuthUtilities dictionaryFromUser:user] ] thisObject:nil];
                         }
                       }];
}

- (void)signOut:(id)arguments
{
  ENSURE_UI_THREAD(signOut, arguments);
  ENSURE_SINGLE_ARG(arguments, NSDictionary);

  KrollCallback *successCallback;
  KrollCallback *errorCallback;

  ENSURE_ARG_OR_NIL_FOR_KEY(successCallback, arguments, @"success", KrollCallback);
  ENSURE_ARG_OR_NIL_FOR_KEY(errorCallback, arguments, @"error", KrollCallback);

  NSError *authError;
  BOOL status = [[FIRAuth auth] signOut:&authError]; //Note: odd signOut seems to always return true!?

  if (status && successCallback != nil) {
    // Sign-out succeeded
    [successCallback call:@[ @"success" ] thisObject:nil];
  } else if (errorCallback != nil) {
    [errorCallback call:@[ [FirebaseAuthUtilities dictionaryFromError:authError] ] thisObject:nil];
  }
}

- (void)sendPasswordResetWithEmail:(id)arguments
{
  ENSURE_UI_THREAD(sendPasswordResetWithEmail, arguments);
  ENSURE_SINGLE_ARG(arguments, NSDictionary);

  KrollCallback *successCallback;
  KrollCallback *errorCallback;
  NSString *email;

  ENSURE_ARG_OR_NIL_FOR_KEY(successCallback, arguments, @"success", KrollCallback);
  ENSURE_ARG_OR_NIL_FOR_KEY(errorCallback, arguments, @"error", KrollCallback);
  ENSURE_ARG_FOR_KEY(email, arguments, @"email", NSString);

  [[FIRAuth auth] sendPasswordResetWithEmail:email
                                  completion:^(NSError *error) {
                                    if (errorCallback != nil && error != nil) {
                                      [errorCallback call:@[ @{ @"success" : NUMBOOL(NO) } ] thisObject:nil];
                                    } else if (successCallback != nil) {
                                      [successCallback call:@[ @{ @"success" : NUMBOOL(YES) } ] thisObject:nil];
                                    }
                                  }];
}

- (NSDictionary *)currentUser
{
  return [FirebaseAuthUtilities dictionaryFromUser:[[FIRAuth auth] currentUser]];
}

@end
