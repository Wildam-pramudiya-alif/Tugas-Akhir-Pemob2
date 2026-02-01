plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

import java.util.Properties
import java.io.FileInputStream

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")


if (keystorePropertiesFile.exists()) {
    FileInputStream(keystorePropertiesFile).use {
        keystoreProperties.load(it)
    }
} else {
    throw GradleException("key.properties not found at android/key.properties")
}

android {
    namespace = "com.example.tugas_akhir_pemob2"
    compileSdk = 34
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.tugas_akhir_pemob2"
        minSdk = flutter.minSdkVersion
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    signingConfigs {
    create("release") {
        keyAlias = keystoreProperties["keyAlias"]?.toString()
            ?: error("keyAlias missing in key.properties")
        keyPassword = keystoreProperties["keyPassword"]?.toString()
            ?: error("keyPassword missing in key.properties")
        storeFile = file(
            keystoreProperties["storeFile"]?.toString()
                ?: error("storeFile missing in key.properties")
        )
        storePassword = keystoreProperties["storePassword"]?.toString()
            ?: error("storePassword missing in key.properties")
    }
}


    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}
