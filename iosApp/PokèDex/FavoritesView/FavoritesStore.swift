//
//  FavoritesStore.swift
//  PokèDex
//
//  Created by Dharamrajsinh Jadeja on 05/04/26.
//


import shared
import Combine
import KMPNativeCoroutinesAsync
import OSLog

@MainActor
final class FavoritesStore: ObservableObject {
    @Published private(set) var favorites: [Pokemon] = []
    
    private let viewModel: FavoritesViewModel
    private var task: Task<Void, Never>?
    
    init(repository: PokemonRepository) {
        viewModel = FavoritesViewModel(repository: repository)
        startObserving()
    }
    
    /// Start listening to favorites updates.
    private func startObserving() {
        task?.cancel()
        task = Task { [weak self] in
            guard let self else { return }
            do {
                for try await newFavorites in asyncSequence(for: viewModel.favoritesFlow) {
                    self.favorites = newFavorites
                }
            } catch {
                os_log("Error collecting favorites: \(error)")
                self.favorites = []
            }
        }
    }
    
    /// Refresh favorites list (useful when returning to tab)
    func refresh() {
        os_log("Refreshing favorites")
    }
    
    deinit {
        task?.cancel()
        viewModel.onCleared()
    }
}
