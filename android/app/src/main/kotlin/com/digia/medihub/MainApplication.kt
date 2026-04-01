package com.digia.medihub

import com.webengage.sdk.android.WebEngageConfig
import com.webengage.webengage_plugin.WebengageInitializer
import io.flutter.app.FlutterApplication

class MainApplication : FlutterApplication() {

    override fun onCreate() {
        super.onCreate()
        val webEngageConfig =
                WebEngageConfig.Builder()
                        .setWebEngageKey("YOUR_WEBENGAGE_KEY")
                        .setDebugMode(true) // only in development mode
                        .build()
        WebengageInitializer.initialize(this, webEngageConfig)
    }
}
