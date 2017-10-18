/**
 * titanium-firebase-auth
 *
 * Created by Hans Knoechel
 * Copyright (c) 2017 Axway Appcelerator. All rights reserved.
 */

#import <Foundation/Foundation.h>

@class FIRUser, FIRAdditionalUserInfo, FIRAuthCredential, FIRActionCodeSettings;

NS_ASSUME_NONNULL_BEGIN

@interface FirebaseAuthUtilities : NSObject

+ (NSDictionary * _Nullable)dictionaryFromUser:(FIRUser * _Nullable)user;

+ (NSDictionary * _Nullable)dictionaryFromError:(NSError * _Nullable)error;

+ (NSDictionary * _Nullable)dictionaryFromAdditionalUserInfo:(FIRAdditionalUserInfo * _Nullable)additionalUserInfo;

+ (FIRActionCodeSettings *)actionCodeSettingsFromDictionary:(NSDictionary<NSString *, id> *)dictionary;

@end

NS_ASSUME_NONNULL_END
