//
//  FavouritesViewModel.swift
//  iosApp
//
//  Created by Akash K on 13/04/26.
//

import Foundation
import Combine
import shared

final class FavouritesViewModel: ObservableObject {

    @Published private(set) var favorites: [FavoritePokemon] = []
    private let viewModel: FavoritesViewModel
    private var favoritesTask: Task<Void, Never>?

    init(repository: PokemonRepository) {
        self.viewModel = FavoritesViewModel(repository: repository)

        if let currentFavorites = viewModel.favorites.value as? [FavoritePokemon] {
            favorites = currentFavorites
        }

        observeFavorites()
    }

    deinit {
        favoritesTask?.cancel()
        viewModel.onCleared()
    }

    private func observeFavorites() {
        let favoritesFlow = viewModel.favorites

        favoritesTask = Task { [weak self] in
            for await items in favoritesFlow.stream(of: [FavoritePokemon].self) {
                guard let self else { return }
                await MainActor.run {
                    self.favorites = items
                }
            }
        }
    }
}
