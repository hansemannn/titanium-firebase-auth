/**
 * Titanium Firebase Auth
 * Appcelerator Titanium Mobile
 * Copyright (c) 2018-present by Hans Knöchel. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 *
 */
package firebase.auth;

import org.appcelerator.kroll.KrollModule;
import org.appcelerator.kroll.KrollDict;
import org.appcelerator.kroll.KrollFunction;
import org.appcelerator.kroll.annotations.Kroll;

import org.appcelerator.titanium.TiApplication;
import org.appcelerator.kroll.common.Log;
import org.appcelerator.kroll.common.TiConfig;

import android.app.Activity;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;

@Kroll.module(name = "TitaniumFirebaseAuth", id = "firebase.auth")
public class TitaniumFirebaseAuthModule extends KrollModule
{
	private static final String LCAT = "TitaniumFirebaseAuthModule";
	private static final boolean DBG = TiConfig.LOGD;

	private FirebaseAuth mAuth;

	public TitaniumFirebaseAuthModule()
	{
		super();
	}

	@Override
	public void onStart(Activity activity)
	{
		mAuth = FirebaseAuth.getInstance();

		super.onStart(activity);
	}

	@Kroll.method
	public void createUserWithEmail(KrollDict params)
	{
		String email = (String) params.get("email");
		String password = (String) params.get("password");
		final KrollFunction callback = (KrollFunction) params.get("callback");

		Activity activity = TiApplication.getInstance().getCurrentActivity();

		mAuth.createUserWithEmailAndPassword(email, password)
			.addOnCompleteListener(activity, new OnCompleteListener<AuthResult>() {
				@Override
				public void onComplete(Task<AuthResult> task)
				{
					KrollDict event = new KrollDict();
					event.put("success", task.isSuccessful());

					if (task.isSuccessful()) {
						event.put("user", dictionaryFromUser(mAuth.getCurrentUser()));
					} else {
						event.put("code", 0);
						event.put("description", task.getException().getMessage());
					}
					callback.callAsync(getKrollObject(), event);
				}
			});
	}

	@Kroll.getProperty
	public KrollDict getCurrentUser()
	{
		return dictionaryFromUser(mAuth.getCurrentUser());
	}

	//  "cannot find symbol"
	//
	//  @Kroll.getProperty
	//  public String getLanguageCode()
	//  {
	//    return mAuth.getLanguageCode();
	//  }

	//  "OnSuccessListener" issues
	//
	//  @Kroll.method
	//  public void getIdToken(final KrollFunction callback, boolean forceRefresh)
	//  {
	//    try {
	//      mAuth.getCurrentUser()
	//        .getIdToken(forceRefresh)
	//        .addOnSuccessListener(new OnSuccessListener<GetTokenResult>() {
	//          @Override
	//          public void onSuccess(GetTokenResult result)
	//          {
	//            KrollDict event = new KrollDict();
	//            event.put("success", true);
	//            event.put("token", result.getToken());
	//            callback.callAsync(getKrollObject(), event);
	//          }
	//        });
	//    } catch (FirebaseAuthInvalidUserException e) {
	//      KrollDict event = new KrollDict();
	//      event.put("success", false);
	//      event.put("error", e.getMessage());
	//      callback.callAsync(getKrollObject(), event);
	//    }
	//  }

	private KrollDict dictionaryFromUser(FirebaseUser user)
	{
		if (user == null) {
			return null;
		}

		KrollDict result = new KrollDict();
		result.put("email", user.getEmail());
		result.put("phoneNumber", user.getPhoneNumber());
		result.put("providerID", user.getProviderId());
		result.put("uid", user.getUid());
		result.put("photoURL", user.getPhotoUrl().toString());
		result.put("displayName", user.getDisplayName());

		return result;
	}
}
