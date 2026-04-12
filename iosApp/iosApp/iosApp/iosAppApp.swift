//
//  iosAppApp.swift
//  iosApp
//
//  Created by Akash K on 12/04/26.
//

import SwiftUI
import shared

@main
struct iosAppApp: App {
    
    init() {
        _ = KoinDependencyManager.shared
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
