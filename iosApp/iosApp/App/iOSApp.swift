import SwiftUI
import shared

@main
struct iOSApp: App {

    init() {
        // Triggers Koin initialisation and repository resolution once.
        _ = KoinDependencies.shared
    }

    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
    }
}
