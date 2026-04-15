import SwiftUI
import shared

@main
struct iOSApp: App {
    init() {
        ModulesKt.doInitKoin(
            driverFactory: DatabaseDriverFactory(),
            enableNetworkLogs: true,
            appDeclaration: { _ in }
        )
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
