plugins {
    id("com.android.application") version "8.7.3"
    id("org.jetbrains.kotlin.android") version "2.1.0"
    // Flutter plugin is automatically applied by Flutter, no need to declare manually
}

android {
    namespace = "com.example.middle_ware"
    compileSdk = 34
    ndkVersion = "25.1.8937393"

    defaultConfig {
        applicationId = "com.example.middle_ware"
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")

    implementation("androidx.browser:browser:1.6.0") {
        isForce = true
    }

    implementation("androidx.core:core:1.12.0") {
        isForce = true
    }

    implementation("androidx.core:core-ktx:1.12.0") {
        isForce = true
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Optional: custom build dir
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
