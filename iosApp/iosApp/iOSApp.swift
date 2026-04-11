import SwiftUI
import shared

@main
struct iOSApp: App {

    init() {
        KoinHelper.start()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(nil) // Supports both light & dark
        }
    }
}
