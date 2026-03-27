import java.util.Base64
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Decode dart-defines injected by --dart-define-from-file=config/secrets.json
// Flutter encodes each KEY=VALUE pair as base64 and passes them comma-separated.
val dartDefinesEncoded = project.findProperty("dart-defines") as String? ?: ""
val dartDefines = mutableMapOf<String, String>()
if (dartDefinesEncoded.isNotEmpty()) {
    dartDefinesEncoded.split(",").forEach { enc ->
        val decoded = String(Base64.getDecoder().decode(enc.trim()))
        val idx = decoded.indexOf('=')
        if (idx > 0) dartDefines[decoded.substring(0, idx)] = decoded.substring(idx + 1)
    }
}
fun dartStr(key: String) = dartDefines[key] ?: ""

android {
    namespace = "com.digia.medihub_flutter"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.digia.medihub_flutter"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        manifestPlaceholders += mapOf(
            "CLEVERTAP_ACCOUNT_ID" to dartStr("CLEVERTAP_ACCOUNT_ID"),
            "CLEVERTAP_TOKEN" to dartStr("CLEVERTAP_TOKEN"),
            "CLEVERTAP_REGION" to dartStr("CLEVERTAP_REGION"),
        )
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
