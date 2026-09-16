import java.io.FileInputStream
import java.util.Base64
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Fallback values, used when the build runs without --dart-define-from-file.
// A key missing from both places would end up in the APK as the string "null".
val dartEnvironmentVariables = mutableMapOf(
    "APP_NAME" to "Sun Shine",
    "APP_SUFFIX" to "",
    "APP_VERSION" to "1.0.0",
    "APP_VERSION_CODE" to "1",
)

// The Flutter Gradle plugin passes every --dart-define as the `dart-defines`
// property: base64-encoded KEY=VALUE pairs joined by commas.
if (project.hasProperty("dart-defines")) {
    dartEnvironmentVariables += (project.property("dart-defines") as String)
        .split(",")
        .map { String(Base64.getDecoder().decode(it), Charsets.UTF_8) }
        .filter { it.contains("=") }
        .associate { it.substringBefore("=") to it.substringAfter("=") }
}

// Written by the CI workflow from the environment's GitHub secrets; absent on
// a developer machine, where release builds fall back to the debug key.
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("signin.properties")
if (keystorePropertiesFile.exists()) {
    FileInputStream(keystorePropertiesFile).use { keystoreProperties.load(it) }
}

android {
    namespace = "com.sunshine.sunshine"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.sunshine.sunshine"
        applicationIdSuffix = dartEnvironmentVariables["APP_SUFFIX"]
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = dartEnvironmentVariables["APP_VERSION_CODE"]!!.toInt()
        versionName = dartEnvironmentVariables["APP_VERSION"]
        resValue("string", "app_name", dartEnvironmentVariables["APP_NAME"]!!)
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
            storeFile = keystoreProperties.getProperty("storeFile")?.let { file(it) }
            storePassword = keystoreProperties.getProperty("storePassword")
        }
    }

    buildTypes {
        release {
            signingConfig = if (keystorePropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                // Keeps `flutter run --release` working locally without a keystore.
                signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}
