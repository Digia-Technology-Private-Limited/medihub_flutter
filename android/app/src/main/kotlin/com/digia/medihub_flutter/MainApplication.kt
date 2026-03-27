package com.digia.medihub_flutter

import android.app.Application
import com.clevertap.android.sdk.ActivityLifecycleCallback
import com.clevertap.clevertap_plugin.ClevertapCustomTemplates

class MainApplication : Application() {
	override fun onCreate() {
		ActivityLifecycleCallback.register(this)
		super.onCreate()
	}
}
