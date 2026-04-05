import org.jetbrains.kotlin.gradle.plugin.mpp.apple.XCFramework

plugins {
    alias(libs.plugins.kotlin.multiplatform)
}

kotlin {
    val xcf = XCFramework("iosInterop")
    listOf(
        iosX64(),
        iosArm64(),
        iosSimulatorArm64(),
    ).forEach {
        it.binaries.framework {
            baseName = "iosInterop"
            xcf.add(this)
            isStatic = true
        }
    }

    sourceSets {
        commonMain.dependencies {
            // Full embed of `shared` so `./gradlew :iosInterop:assembleIosInteropDebugXCFramework` produces a single framework.
            // Do not link this alongside the `shared` CocoaPods framework in the same app (duplicate Kotlin/Native symbols).
            api(project(":shared"))
            implementation(libs.koin.core)
        }
    }
}
