//
//  RootView.swift
//  PokèDex
//
//  Created by Dharamrajsinh Jadeja on 04/04/26.
//

import SwiftUI
import shared

/// Root view container that handles app initialization and navigation
struct RootView: View {
    @State private var selectedTab = 0
    @State private var repository: PokemonRepository?
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var favoritesStore: FavoritesStore?
    
    var body: some View {
        Group {
            if isLoading {
                InitializingView()
            } else if let repo = repository {
                TabView(selection: $selectedTab) {
                    // Pokemon List Tab
                    PokemonListView(repository: repo)
                        .tabItem {
                            Label("List", systemImage: "list.bullet")
                        }
                        .tag(0)
                    
                    // Favorites Tab
                    FavoritesView(
                        repository: repo,
                    )
                    .tabItem {
                        Label("Favorites", systemImage: "heart.fill")
                    }
                    .tag(1)
                }
            } else {
                FailedInitializationView(
                    errorMessage: errorMessage,
                    onRetry: initialize
                )
            }
        }
        .task {
            initialize()
        }
    }
    
    private func initialize() {
        do {
            repository = try ModulesKt.getRepository()
            errorMessage = nil
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
}

// MARK: - Subviews
private struct InitializingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Initializing app...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct FailedInitializationView: View {
    let errorMessage: String?
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundStyle(.orange)
            Text("Initialization Failed")
                .font(.headline)
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            Button(action: onRetry) {
                Text("Retry")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
