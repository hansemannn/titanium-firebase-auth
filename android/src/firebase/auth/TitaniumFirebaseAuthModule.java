/**
 * Titanium Firebase Auth
 * Appcelerator Titanium Mobile
 * Copyright (c) 2018-present by Hans Knöchel. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 *
 */
package firebase.auth;

import android.app.Activity;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.google.android.gms.tasks.OnCanceledListener;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.ActionCodeResult;
import com.google.firebase.auth.AuthCredential;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.auth.GetTokenResult;
import com.google.firebase.auth.GoogleAuthProvider;
import com.google.firebase.auth.SignInMethodQueryResult;
import java.util.List;

import org.appcelerator.kroll.KrollDict;
import org.appcelerator.kroll.KrollFunction;
import org.appcelerator.kroll.KrollModule;
import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.kroll.common.Log;
import org.appcelerator.titanium.TiApplication;

@Kroll.module(name = "TitaniumFirebaseAuth", id = "firebase.auth")
public class TitaniumFirebaseAuthModule extends KrollModule
{
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
	protected void initActivity(Activity activity)
	{
		mAuth = FirebaseAuth.getInstance();
	}

	@Override
	public void onStart(Activity activity)
	{
		super.onStart(activity);
	}

	@Kroll.method
	public void init()
	{
		mAuth = FirebaseAuth.getInstance();
	}

	@Kroll.method
	public void fetchProviders(KrollDict params)
	{
		String email = (String) params.get("email");
		final KrollFunction callback = (KrollFunction) params.get("callback");

		Task<SignInMethodQueryResult> result = mAuth.fetchSignInMethodsForEmail(email);

		result.addOnSuccessListener(new OnSuccessListener<SignInMethodQueryResult>() {
			@Override
			public void onSuccess(SignInMethodQueryResult arg0)
			{

				List<String> providers = arg0.getSignInMethods();
				String[] result = new String[providers.size()];

				KrollDict event = new KrollDict();
				event.put("success", true);
				event.put("providers", providers.toArray(result));
				callback.callAsync(getKrollObject(), event);
			}
		});

		result.addOnFailureListener(new OnFailureListener() {
			@Override
			public void onFailure(Exception arg0)
			{
				KrollDict event = new KrollDict();
				event.put("success", false);
				event.put("code", 0);
				event.put("description", arg0.getMessage());
				callback.callAsync(getKrollObject(), event);
			}
		});

		result.addOnCanceledListener(new OnCanceledListener() {
			@Override
			public void onCanceled()
			{
				KrollDict event = new KrollDict();
				event.put("success", false);
				event.put("code", 0);
				event.put("description", "cancelled");
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
			.addOnCompleteListener(activity, task -> {
				final KrollDict event = new KrollDict();

				if (!task.isSuccessful()) {
					event.put("success", false);
					event.put("code", 0);
					event.put("description", task.getException().getMessage());
					callback.callAsync(getKrollObject(), event);
					return;
				}

				mAuth.getCurrentUser().getIdToken(false).addOnSuccessListener(new OnSuccessListener<GetTokenResult>() {
					@Override
					public void onSuccess(GetTokenResult result) {
						event.put("success", true);
						event.put("token", result.getToken());
						event.put("user", dictionaryFromUser(mAuth.getCurrentUser()));

						callback.callAsync(getKrollObject(), event);
					}
				}).addOnFailureListener(exception -> {
					event.put("success", false);
					event.put("code", 0);
					event.put("description", exception.getMessage());

					callback.callAsync(getKrollObject(), event);
				});
			});
	}

	@Kroll.method
	public void signInWithEmail(KrollDict params)
	{
		String email = (String) params.get("email");
		String password = (String) params.get("password");
		final KrollFunction callback = (KrollFunction) params.get("callback");

		mAuth.signInWithEmailAndPassword(email, password)
			.addOnSuccessListener(authResult -> mAuth.getCurrentUser()
				.getIdToken(false)
				.addOnSuccessListener(new OnSuccessListener<GetTokenResult>() {
					@Override
					public void onSuccess(GetTokenResult result)
					{
						KrollDict event = new KrollDict();
						event.put("success", true);
						event.put("token", result.getToken());
						event.put("user", dictionaryFromUser(mAuth.getCurrentUser()));
						callback.callAsync(getKrollObject(), event);
					}
				})
				.addOnFailureListener(exception -> {
					KrollDict event = new KrollDict();
					event.put("success", false);
					event.put("code", 0);
					event.put("description", exception.getMessage());
					callback.callAsync(getKrollObject(), event);
				}))
			.addOnFailureListener(exception -> {
				KrollDict event = new KrollDict();
				event.put("success", false);
				event.put("code", 0);
				event.put("description", exception.getMessage());
				callback.callAsync(getKrollObject(), event);
			});
	}

	@Kroll.method
	public void signInWithGoogle(KrollDict params)
	{
		String idToken = params.getString("idToken");
		final KrollFunction callback = (KrollFunction) params.get("callback");
		if (idToken.equals("")) {
			Log.e("Firebase Auth", "idToken is empty");
			return;
		}
		AuthCredential firebaseCredential = GoogleAuthProvider.getCredential(idToken, null);
		mAuth.signInWithCredential(firebaseCredential)
				.addOnCompleteListener(TiApplication.getAppCurrentActivity(), new OnCompleteListener<AuthResult>() {
					@Override
					public void onComplete(@NonNull Task<AuthResult> task) {
						if (task.isSuccessful()) {
							// Sign in success, update UI with the signed-in user's information
							FirebaseUser user = mAuth.getCurrentUser();

							KrollDict event = new KrollDict();
							event.put("success", true);
							event.put("user", dictionaryFromUser(mAuth.getCurrentUser()));
							callback.callAsync(getKrollObject(), event);
						} else {
							// If sign in fails, display a message to the user.
							KrollDict event = new KrollDict();
							event.put("success", false);
							event.put("code", 0);
							event.put("description", task.getException().getMessage());
							callback.callAsync(getKrollObject(), event);
						}
					}
				});

	}

	@Kroll.method
	public void sendPasswordResetWithEmail(KrollDict params)
	{
		String email = (String) params.get("email");
		final KrollFunction callback = (KrollFunction) params.get("callback");

		mAuth.sendPasswordResetEmail(email).addOnCompleteListener(new OnCompleteListener<Void>() {
            @Override
            public void onComplete(Task<Void> task) {
				KrollDict event = new KrollDict();
				event.put("success", task.isSuccessful());
				callback.callAsync(getKrollObject(), event);
            }
        });
	}

	@Kroll.method
	public void checkActionCode(KrollDict params)
	{
		String code = (String) params.get("code");
		final KrollFunction callback = (KrollFunction) params.get("callback");

		mAuth.checkActionCode(code).addOnCompleteListener(new OnCompleteListener<ActionCodeResult>() {
			@Override
			public void onComplete(Task<ActionCodeResult> task) {
				KrollDict event = new KrollDict();
				if (task.isSuccessful()) {
					event.put("success", task.isSuccessful());
					event.put("operation", task.getResult().getOperation());
				} else {
					event.put("success", false);
				}
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
			.addOnCompleteListener(task -> {
				KrollDict event = new KrollDict();
				event.put("success", task.isSuccessful());

				if (task.isSuccessful()) {
					event.put("user", dictionaryFromUser(mAuth.getCurrentUser()));
				} else {
					event.put("code", 0);
					event.put("description", task.getException().getMessage());
				}
				callback.callAsync(getKrollObject(), event);
			});
	}

	@Kroll.method
	public void signInAnonymously(final KrollFunction callback)
	{
		mAuth.signInAnonymously()
			.addOnSuccessListener(authResult -> {
				KrollDict event = new KrollDict();
				event.put("success", true);
				event.put("user", dictionaryFromUser(mAuth.getCurrentUser()));
				callback.callAsync(getKrollObject(), event);
			})
			.addOnFailureListener(exception -> {
				KrollDict event = new KrollDict();
				event.put("success", false);
				event.put("code", 0);
				event.put("description", exception.getMessage());
				callback.callAsync(getKrollObject(), event);
			});
	}

	@Kroll.method
	public void signInWithCustomToken(KrollDict params)
	{

		final String mCustomToken = (String) params.get("customToken");
		final KrollFunction callback = (KrollFunction) params.get("callback");

		Activity activity = TiApplication.getInstance().getCurrentActivity();

		Task<AuthResult> result = mAuth.signInWithCustomToken(mCustomToken);

		result.addOnCompleteListener(activity, task -> {

			if (task.isSuccessful()) {
				KrollDict event = new KrollDict();
				event.put("success", task.isSuccessful());
				event.put("user", dictionaryFromUser(mAuth.getCurrentUser()));
				callback.callAsync(getKrollObject(), event);
			} else {
				KrollDict event = new KrollDict();
				event.put("success", task.isSuccessful());
				event.put("description", task.getException().getMessage());
				callback.callAsync(getKrollObject(), event);
			}
		});
	}

	@Kroll.method
	public void signOut(@Nullable KrollFunction callback)
	{
		mAuth.signOut();

		// For parity with iOS, use callback if available
		if (callback != null) {
			KrollDict event = new KrollDict();
			event.put("success", true);
			callback.callAsync(getKrollObject(), event);
		}
	}

	@Kroll.method
	public void deleteUser(KrollFunction callback) {
		if (mAuth.getCurrentUser() == null) {
			KrollDict event = new KrollDict();
			event.put("success", false);
			callback.callAsync(getKrollObject(), event);
			return;
		}

		mAuth.getCurrentUser().delete().addOnCompleteListener(task -> {
			KrollDict event = new KrollDict();
			event.put("success", task.isSuccessful());
			callback.callAsync(getKrollObject(), event);
		});
	}

	@Kroll.method
	public void fetchIDToken(boolean forceRefresh, final KrollFunction callback)
	{
		if (mAuth.getCurrentUser() != null) {
		mAuth.getCurrentUser()
			.getIdToken(forceRefresh)
			.addOnSuccessListener(result -> {
				KrollDict event = new KrollDict();
				event.put("success", true);
				event.put("token", result.getToken());
				callback.callAsync(getKrollObject(), event);
			})
			.addOnFailureListener(exception -> {
				KrollDict event = new KrollDict();
				event.put("success", false);
				event.put("code", 0);
				event.put("description", exception.getMessage());
				callback.callAsync(getKrollObject(), event);
			});
		} else {
			KrollDict event = new KrollDict();
			event.put("success", false);
			event.put("code", 0);
			event.put("description", "No user");
			callback.callAsync(getKrollObject(), event);
		}
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
		return mAuth.getLanguageCode();
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
		result.put("photoURL", user.getPhotoUrl() != null ? user.getPhotoUrl().toString() : null);
		result.put("displayName", user.getDisplayName());

		return result;
	}
}
