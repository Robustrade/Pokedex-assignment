//
//  Poke_DexApp.swift
//  PokèDex
//
//  Created by Dharamrajsinh Jadeja on 04/04/26.
//

import SwiftUI
import shared

@main
struct Poke_DexApp: App {
    init() {
        // Initialize Koin with platform-specific DatabaseDriverFactory
        ModulesKt.doInitKoin(
            driverFactory: DatabaseDriverFactory(),
            enableNetworkLogs: true
        ) { _ in }
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
