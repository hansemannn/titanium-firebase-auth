//
//  FirebaseAuthUtilities.m
//  titanium-firebase-auth
//
//  Created by Hans Knöchel on 16.10.17.
//

#import "FirebaseAuthUtilities.h"
#import "TiBase.h"

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

@end
