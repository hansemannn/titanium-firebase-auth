/**
 * titanium-firebase-auth
 *
 * Created by Hans Knoechel
 * Copyright (c) 2017 Axway Appcelerator. All rights reserved.
 */

#import "FirebaseAuthUtilities.h"
#import "TiBase.h"
#import "TiUtils.h"

#import <FirebaseAuth/FirebaseAuth.h>

@implementation FirebaseAuthUtilities

+ (NSDictionary *)dictionaryFromUser:(FIRUser *)user
{
  if (!user) {
    return nil;
  }

  return @{
    @"email" : NULL_IF_NIL([user email]),
    @"phoneNumber" : NULL_IF_NIL([user phoneNumber]),
    @"providerID" : [user providerID],
    @"uid" : [user uid],
    @"photoURL" : NULL_IF_NIL([[user photoURL] absoluteString]),
    @"displayName" : NULL_IF_NIL([user displayName])
  };
}

+ (NSDictionary *)dictionaryFromError:(NSError *)error
{
  if (!error) {
    return nil;
  }

  return @{
    @"success": @NO,
    @"code" : NUMINTEGER([error code]),
    @"description" : [error localizedDescription]
  };
}

+ (NSDictionary *)dictionaryFromAdditionalUserInfo:(FIRAdditionalUserInfo *)additionalUserInfo
{
  if (!additionalUserInfo) {
    return nil;
  }
  
  return @{
    @"providerID": additionalUserInfo.providerID,
    @"newUser": NUMBOOL(additionalUserInfo.isNewUser),
    @"profile": additionalUserInfo.profile,
  };
}

+ (FIRActionCodeSettings *)actionCodeSettingsFromDictionary:(NSDictionary<NSString *, id> *)dictionary
{
  FIRActionCodeSettings *actionCodeSettings = [[FIRActionCodeSettings alloc] init];

  NSURL *url = [TiUtils toURL:[dictionary objectForKey:@"url"] proxy:nil];
  NSNumber *handleCodeInApp = [dictionary objectForKey:@"handleCodeInApp"];
  NSString *iOSBundleID = [dictionary objectForKey:@"iOSBundleID"];
  NSDictionary *android = [dictionary objectForKey:@"android"];

  if (url != nil) {
    [actionCodeSettings setURL:url];
  }
  
  if (handleCodeInApp != nil) {
    [actionCodeSettings setHandleCodeInApp:[TiUtils boolValue:handleCodeInApp]];
  }
  
  if (iOSBundleID != nil) {
    [actionCodeSettings setIOSBundleID:iOSBundleID];
  }
  
  if (android != nil) {
    NSString *packageName = [android objectForKey:@"androidPackageName"];
    NSString *minimumVersion = [android objectForKey:@"androidMinimumVersion"];
    NSNumber *installIfNotAvailable = [android objectForKey:@"androidInstallIfNotAvailable"];
    
    if (packageName == nil) {
      NSLog(@"[ERROR] Trying to set Android-related action-code-settings without specifying the required \"packageName\" key.");
    }
    
    [actionCodeSettings setAndroidPackageName:packageName
                        installIfNotAvailable:[TiUtils boolValue:installIfNotAvailable]
                               minimumVersion:minimumVersion];
  }
  
  return actionCodeSettings;
}

@end
