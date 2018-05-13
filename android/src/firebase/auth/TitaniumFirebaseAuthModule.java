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

import java.util.List;

import android.app.Activity;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;

import com.google.firebase.auth.ActionCodeSettings;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.auth.GetTokenResult;
import com.google.firebase.auth.ProviderQueryResult;

@Kroll.module(name = "TitaniumFirebaseAuth", id = "firebase.auth")
public class TitaniumFirebaseAuthModule extends KrollModule
{
	private static final String LCAT = "TitaniumFirebaseAuthModule";
	private static final boolean DBG = TiConfig.LOGD;

	private FirebaseAuth mAuth;

	@Kroll.constant
	public static final int AUTH_PROVIDER_TYPE_UNKNOWN = 0;

	@Kroll.constant
	public static final int AUTH_PROVIDER_TYPE_FACEBOOK = 1;

	@Kroll.constant
	public static final int AUTH_PROVIDER_TYPE_TWITTER = 2;

	@Kroll.constant
	public static final int AUTH_PROVIDER_TYPE_GOOGLE = 3;

	@Kroll.constant
	public static final int AUTH_PROVIDER_TYPE_GITHUB = 4;

	@Kroll.constant
	public static final int AUTH_PROVIDER_TYPE_PASSWORD = 5;

	@Kroll.constant
	public static final int AUTH_PROVIDER_TYPE_PHONE = 6;

	@Kroll.constant
	public static final int AUTH_PROVIDER_TYPE_OAUTH = 7;

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
	public void fetchProviders(KrollDict params)
	{
		String email = (String) params.get("email");
		final KrollFunction callback = (KrollFunction) params.get("callback");

		mAuth.fetchProvidersForEmail(email).addOnCompleteListener(new OnCompleteListener<ProviderQueryResult>() {
			@Override
			public void onComplete(Task<ProviderQueryResult> task)
			{
				KrollDict event = new KrollDict();
				event.put("success", task.isSuccessful());

				if (task.isSuccessful()) {
					List<String> providers = task.getResult().getProviders();
					String[] result = new String[providers.size()];
					event.put("providers", providers.toArray(result));
				} else {
					event.put("code", 0);
					event.put("description", task.getException().getMessage());
				}

				callback.callAsync(getKrollObject(), event);
			}
		});
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

	@Kroll.method
	public void signInWithEmail(KrollDict params)
	{
		String email = (String) params.get("email");
		String password = (String) params.get("password");
		final KrollFunction callback = (KrollFunction) params.get("callback");

		mAuth.signInWithEmailAndPassword(email, password)
			.addOnSuccessListener(new OnSuccessListener<AuthResult>() {
				@Override
				public void onSuccess(AuthResult authResult)
				{
					KrollDict event = new KrollDict();
					event.put("success", true);
					event.put("user", dictionaryFromUser(mAuth.getCurrentUser()));
					callback.callAsync(getKrollObject(), event);
				}
			})
			.addOnFailureListener(new OnFailureListener() {
				@Override
				public void onFailure(Exception exception)
				{
					KrollDict event = new KrollDict();
					event.put("success", false);
					event.put("code", 0);
					event.put("description", exception.getMessage());
					callback.callAsync(getKrollObject(), event);
				}
			});
	}

	@Kroll.method
	public void signInWithCredential(KrollDict params)
	{
		TitaniumFirebaseAuthCredentialProxy credential = (TitaniumFirebaseAuthCredentialProxy) params.get("credential");
		final KrollFunction callback = (KrollFunction) params.get("callback");

		mAuth.signInWithCredential(credential.getCredential())
			.addOnCompleteListener(new OnCompleteListener<AuthResult>() {
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

	@Kroll.method
	public void signInAnonymously(final KrollFunction callback)
	{
		mAuth.signInAnonymously()
			.addOnSuccessListener(new OnSuccessListener<AuthResult>() {
				@Override
				public void onSuccess(AuthResult authResult)
				{
					KrollDict event = new KrollDict();
					event.put("success", true);
					event.put("user", dictionaryFromUser(mAuth.getCurrentUser()));
					callback.callAsync(getKrollObject(), event);
				}
			})
			.addOnFailureListener(new OnFailureListener() {
				@Override
				public void onFailure(Exception exception)
				{
					KrollDict event = new KrollDict();
					event.put("success", false);
					event.put("code", 0);
					event.put("description", exception.getMessage());
					callback.callAsync(getKrollObject(), event);
				}
			});
	}

	@Kroll.method
	public void sendPasswordResetWithEmail(KrollDict params)
	{
		String email = (String) params.get("email");
		KrollDict actionCodeSettings = (KrollDict) params.get("actionCodeSettings");
		final KrollFunction callback = (KrollFunction) params.get("callback");

		OnCompleteListener<Void> handler = new OnCompleteListener<Void>() {
			@Override
			public void onComplete(Task<Void> task)
			{
				KrollDict event = new KrollDict();
				event.put("success", task.isSuccessful());
				callback.callAsync(getKrollObject(), event);
			}
		};

		if (actionCodeSettings == null) {
			mAuth.sendPasswordResetEmail(email).addOnCompleteListener(handler);
		} else {
			mAuth.sendPasswordResetEmail(email, actionCodeSettingsFromDictionary(actionCodeSettings))
				.addOnCompleteListener(handler);
		}
	}

	@Kroll.method
	public void signOut()
	{
		mAuth.signOut();
	}

	@Kroll.method
	public void fetchIDToken(boolean forceRefresh, final KrollFunction callback)
	{
		mAuth.getCurrentUser()
			.getIdToken(forceRefresh)
			.addOnSuccessListener(new OnSuccessListener<GetTokenResult>() {
				@Override
				public void onSuccess(GetTokenResult result)
				{
					KrollDict event = new KrollDict();
					event.put("success", true);
					event.put("token", result.getToken());
					callback.callAsync(getKrollObject(), event);
				}
			})
			.addOnFailureListener(new OnFailureListener() {
				@Override
				public void onFailure(Exception exception)
				{
					KrollDict event = new KrollDict();
					event.put("success", false);
					event.put("code", 0);
					event.put("description", exception.getMessage());
					callback.callAsync(getKrollObject(), event);
				}
			});
	}

	@Kroll.method
	public TitaniumFirebaseAuthCredentialProxy createAuthCredential(KrollDict params)
	{
		int type = (int) params.get("provider");
		String accessToken = (String) params.get("accessToken");
		String secretToken = (String) params.get("secretToken");
		String providerID = (String) params.get("providerID");
		String IDToken = (String) params.get("IDToken");

		return new TitaniumFirebaseAuthCredentialProxy(type, accessToken, secretToken, providerID, IDToken);
	}

	@Kroll.getProperty
	public KrollDict getCurrentUser()
	{
		return dictionaryFromUser(mAuth.getCurrentUser());
	}

	@Kroll.getProperty
	public String getLanguageCode()
	{
		// return mAuth.getLanguageCode();
		// throws "cannot find symbol"
		return null;
	}

	private ActionCodeSettings actionCodeSettingsFromDictionary(KrollDict params)
	{
		ActionCodeSettings.Builder builder = ActionCodeSettings.newBuilder();

		String url = (String) params.get("url");
		boolean handleCodeInApp = (boolean) params.optBoolean("handleCodeInApp", false);
		KrollDict ios = (KrollDict) params.get("ios");
		KrollDict android = (KrollDict) params.get("android");

		if (url != null) {
			builder = builder.setUrl(url);
		}

		builder = builder.setHandleCodeInApp(handleCodeInApp);

		if (ios != null) {
			if (ios.containsKeyAndNotNull("bundleId")) {
				builder = builder.setIOSBundleId(ios.getString("bundleId"));
			}
		}

		if (android != null) {
			if (!android.containsKeyAndNotNull("packageName")) {
				Log.e(
					LCAT,
					"Trying to set Android-related action-code-settings without specifying the required \"packageName\" key.");
			}

			String packageName = android.getString("packageName");
			String minimumVersion = android.optString("minimumVersion", null);
			boolean installIfNotAvailable = android.optBoolean("installApp", false);

			builder = builder.setAndroidPackageName(packageName, installIfNotAvailable, minimumVersion);
		}

		return builder.build();
	}

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
