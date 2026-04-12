//
//  iosAppApp.swift
//  iosApp
//
//  Created by Akash K on 12/04/26.
//

import SwiftUI

@main
struct iosAppApp: App {
    private let dependencies: ViewModelFactory
    
    init() {
        self.dependencies = AppDependencies()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.viewModelFactory, dependencies)
        }
    }
}
