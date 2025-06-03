plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.clothing_app"  // Keep as-is or match your Firebase package
    compileSdk = 35  // ✅ Updated from 34 to 35

    defaultConfig {
        applicationId = "com.example.clothing_app"
        minSdk = 21
        targetSdk = 35  // ✅ Updated from 34 to 35
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug") // Dev-only, replace for release
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }
}

flutter {
    source = "../.."
}
