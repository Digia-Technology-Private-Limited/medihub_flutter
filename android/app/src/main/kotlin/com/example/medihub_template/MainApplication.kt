package com.example.medihub_template

import com.clevertap.android.sdk.ActivityLifecycleCallback
import com.clevertap.android.sdk.CleverTapAPI
import com.clevertap.clevertap_plugin.CleverTapApplication

class MainApplication : CleverTapApplication() {
    override fun onCreate() {
        CleverTapAPI.setDebugLevel(3)
        ActivityLifecycleCallback.register(this)
        super.onCreate()
    }
}
