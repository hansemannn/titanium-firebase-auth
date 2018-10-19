package firebase.auth;

import org.appcelerator.kroll.KrollDict;
import org.appcelerator.kroll.KrollFunction;
import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.titanium.TiApplication;

import android.net.Uri;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.auth.UserProfileChangeRequest;

@Kroll.module(parentModule = TitaniumFirebaseAuthModule.class)
public class UserModule extends TitaniumFirebaseAuthModule {
	
	private UserModule(FirebaseUser user) {
		super();
		
	}
	@Kroll.onAppCreate
	public static void onAppCreate(TiApplication app) {

	}

	@Kroll.method
	public void updateProfile(KrollDict opts) {
		String displayName = null;
		String photoUrl = null;
		String email = null;
		String password = null;

		FirebaseUser user = FirebaseAuth.getInstance().getCurrentUser();
		if (user == null)
			return;

		if (opts.containsKeyAndNotNull("displayName")) {
			displayName = opts.getString("displayName");
		}
		if (opts.containsKeyAndNotNull("photoUrl")) {
			photoUrl = opts.getString("photoUrl");
		}
		if (opts.containsKeyAndNotNull("email")) {
			email = opts.getString("email");
		}
		if (opts.containsKeyAndNotNull("password")) {
			password = opts.getString("password");
		}
		if (displayName != null || photoUrl != null) {
			UserProfileChangeRequest.Builder builder = new UserProfileChangeRequest.Builder();
			if (displayName != null)
				builder.setDisplayName(displayName);
			if (photoUrl != null)
				builder.setPhotoUri(Uri.parse(photoUrl));
			UserProfileChangeRequest profileUpdates = builder.build();
			user.updateProfile(profileUpdates)
					.addOnCompleteListener(new OnCompleteListener<Void>() {
						@Override
						public void onComplete(@NonNull Task<Void> task) {
							if (task.isSuccessful()) {
								KrollDict event = new KrollDict();
								event.put("success", true);
								sendBack(event);
							}
						}
					}).addOnFailureListener(new OnFailureListener() {
						@Override
						public void onFailure(@NonNull Exception e) {

							KrollDict event = new KrollDict();
							event.put("success", false);
							event.put("types", "profile");
							sendBack(event);

						}
					});

		}
		if (email != null) {
			user.updateEmail(email)
					.addOnCompleteListener(new OnCompleteListener<Void>() {
						@Override
						public void onComplete(@NonNull Task<Void> task) {
							if (task.isSuccessful()) {
								KrollDict event = new KrollDict();
								event.put("success", true);
								sendBack(event);
							}
						}
					}).addOnFailureListener(new OnFailureListener() {
						@Override
						public void onFailure(@NonNull Exception e) {

							KrollDict event = new KrollDict();
							event.put("success", false);
							event.put("types", "email");
							sendBack(event);

						}
					});
		}
		if (password != null) {
			user.updateEmail(password)
					.addOnCompleteListener(new OnCompleteListener<Void>() {
						@Override
						public void onComplete(@NonNull Task<Void> task) {
							if (task.isSuccessful()) {
								KrollDict event = new KrollDict();
								event.put("success", true);
								event.put("types", "password");

								sendBack(event);
							}
						}
					}).addOnFailureListener(new OnFailureListener() {
						@Override
						public void onFailure(@NonNull Exception e) {
							KrollDict event = new KrollDict();
							event.put("success", false);
							sendBack(event);

						}
					});
		}
	}
	
	@Kroll.method
   public static KrollDict dictionaryFromUser(FirebaseUser user) {
		if (user == null)
			return null;
		KrollDict result = new KrollDict();
		result.put("email", user.getEmail());
		result.put("phoneNumber", user.getPhoneNumber());
		result.put("providerID", user.getProviderId());
		result.put("uid", user.getUid());
		Uri photoURL = user.getPhotoUrl();
		if (photoURL != null) {
			result.put("photoURL", photoURL.toString());
		}
		result.put("displayName", user.getDisplayName());
		result.put("isEmailVerified", user.isEmailVerified());
		result.put("isAnonymous", user.isAnonymous());
		
		
		return result;
   }
	@Kroll.method
	public KrollDict getUser() {
		return null;
	}

	private void sendBack(KrollDict event) {
		KrollFunction onChanged = (KrollFunction) getProperty("onChanged");
		if (onChanged != null) {
			onChanged.call(getKrollObject(), new Object[] { event });
		}
		if (this.hasListeners("changed")) {
			this.fireEvent("changed", event);
		}
	}
}
