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

@Kroll.module(name="TitaniumFirebaseAuth", id="firebase.auth")
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
}
