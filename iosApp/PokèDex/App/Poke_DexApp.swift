//
//  Poke_DexApp.swift
//  PokèDex
//
//  Created by Dharamrajsinh Jadeja on 04/04/26.
//

import SwiftUI
import shared
import Kingfisher

@main
struct Poke_DexApp: App {
    init() {
        // Initialize Koin with platform-specific DatabaseDriverFactory
        ModulesKt.doInitKoin(
            driverFactory: DatabaseDriverFactory(),
            enableNetworkLogs: true
        ) { _ in }
        // Kingfisher cache config
        let cache = ImageCache.default
        cache.memoryStorage.config.totalCostLimit = 100 * 1024 * 1024  // 100 MB RAM
        cache.diskStorage.config.sizeLimit = 500 * 1024 * 1024         // 500 MB disk
        cache.diskStorage.config.expiration = .days(7)
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
