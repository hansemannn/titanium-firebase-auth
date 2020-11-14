/**
 * Titanium Firebase Auth
 * Appcelerator Titanium Mobile
 * Copyright (c) 2018-present by Hans Knöchel. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 *
 */
package firebase.auth;

import com.google.firebase.auth.AuthCredential;
import com.google.firebase.auth.EmailAuthProvider;
import com.google.firebase.auth.FacebookAuthProvider;
import com.google.firebase.auth.GithubAuthProvider;
import com.google.firebase.auth.GoogleAuthProvider;
import com.google.firebase.auth.OAuthProvider;
import com.google.firebase.auth.PhoneAuthProvider;
import com.google.firebase.auth.TwitterAuthProvider;

import org.appcelerator.kroll.KrollProxy;
import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.kroll.common.Log;

@Kroll.proxy(creatableInModule = TitaniumFirebaseAuthModule.class)
public class TitaniumFirebaseAuthCredentialProxy extends KrollProxy
{
	private static final String TAG = "AuthCredentialProxy";

	private AuthCredential mAuthCredential;

	// Constructor
	public TitaniumFirebaseAuthCredentialProxy(int provider, String accessToken, String secretToken, String providerID,
											   String IDToken)
	{
		super();

		switch (provider) {
			case TitaniumFirebaseAuthModule.AUTH_PROVIDER_TYPE_FACEBOOK:
				mAuthCredential = FacebookAuthProvider.getCredential(accessToken);
				break;
			case TitaniumFirebaseAuthModule.AUTH_PROVIDER_TYPE_TWITTER:
				mAuthCredential = TwitterAuthProvider.getCredential(accessToken, secretToken);
				break;
			case TitaniumFirebaseAuthModule.AUTH_PROVIDER_TYPE_GOOGLE:
				mAuthCredential = GoogleAuthProvider.getCredential(accessToken, secretToken);
				break;
			case TitaniumFirebaseAuthModule.AUTH_PROVIDER_TYPE_GITHUB:
				mAuthCredential = GithubAuthProvider.getCredential(accessToken);
				break;
			case TitaniumFirebaseAuthModule.AUTH_PROVIDER_TYPE_PASSWORD:
				mAuthCredential = EmailAuthProvider.getCredential(accessToken, secretToken);
				break;
			case TitaniumFirebaseAuthModule.AUTH_PROVIDER_TYPE_PHONE:
				mAuthCredential = PhoneAuthProvider.getCredential(accessToken, secretToken);
				break;
			case TitaniumFirebaseAuthModule.AUTH_PROVIDER_TYPE_OAUTH: {
				mAuthCredential = OAuthProvider.getCredential(IDToken, accessToken, secretToken);
			} break;
			default:
				Log.e(TAG, "Unknown auth-provider-type provided: " + provider);
		}
	}

	public AuthCredential getCredential()
	{
		return mAuthCredential;
	}
}
