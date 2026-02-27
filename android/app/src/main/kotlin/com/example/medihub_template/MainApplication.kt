package com.example.medihub_template

import android.app.Application
import com.moengage.core.DataCenter
import com.moengage.core.MoEngage
import com.moengage.flutter.MoEInitializer

class MainApplication : Application() {
    override fun onCreate() {
        super.onCreate()

        // Correctly pass 'this' as the Application context
        val moEngage = MoEngage.Builder(this, "11WPK0Z2N6HXU5R5DN5HUHYW", DataCenter.DATA_CENTER_1)

        // Use 'this' instead of applicationContext since we are inside the Application class
        MoEInitializer.initialiseDefaultInstance(this, moEngage)
    }
}
