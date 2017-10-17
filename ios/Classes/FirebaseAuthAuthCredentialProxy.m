/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2017 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "FirebaseAuthAuthCredentialProxy.h"

@implementation FirebaseAuthAuthCredentialProxy

- (id)_initWithPageContext:(id<TiEvaluator>)context andAuthCredential:(FIRAuthCredential *)authCredential
{
  if (self = [super _initWithPageContext:context]) {
    _authCredential = authCredential;
  }
  
  return self;
}

@end
