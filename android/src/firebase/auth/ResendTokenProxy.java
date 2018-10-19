/**
 * Titanium Firebase Auth
 * Appcelerator Titanium Mobile
 * Copyright (c) 2018-present by Hans Knöchel. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 *
 */
package firebase.auth;

import org.appcelerator.kroll.KrollProxy;
import org.appcelerator.kroll.annotations.Kroll;
import com.google.firebase.auth.PhoneAuthProvider;

@Kroll.proxy(creatableInModule = TitaniumFirebaseAuthModule.class)
public class ResendTokenProxy extends KrollProxy {
	private PhoneAuthProvider.ForceResendingToken token;

	public ResendTokenProxy(PhoneAuthProvider.ForceResendingToken token) {
		super();
		this.token = token;

	}

	public PhoneAuthProvider.ForceResendingToken getToken() {
		return token;
	}
}
