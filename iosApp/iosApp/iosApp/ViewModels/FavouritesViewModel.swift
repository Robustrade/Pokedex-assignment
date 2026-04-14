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

    @Published private(set) var favorites: [Pokemon] = []
    @Published private(set) var lastErrorMessage: String?
    private let repository: PokemonRepository
    private let viewModel: FavoritesViewModel
    private var favoritesTask: Task<Void, Never>?

    init(repository: PokemonRepository) {
        self.repository = repository
        self.viewModel = FavoritesViewModel(repository: repository)

        if let currentFavorites = viewModel.favorites.value as? [Pokemon] {
            favorites = currentFavorites
        }

        observeFavorites()
    }

    deinit {
        favoritesTask?.cancel()
        viewModel.onCleared()
    }

    func unfavourite(_ pokemon: Pokemon) {
        repository.setFavorite(
            id: pokemon.id,
            name: pokemon.name,
            imageUrl: pokemon.imageUrl,
            isFavorite: false
        ) { [weak self] error in
            guard let self else { return }
            if let error {
                Task { @MainActor in
                    self.lastErrorMessage = error.localizedDescription
                }
            }
        }
    }

    private func observeFavorites() {
        let favoritesFlow = viewModel.favorites

        favoritesTask = Task { [weak self] in
            for await items in favoritesFlow.stream(of: [Pokemon].self) {
                guard let self else { return }
                await MainActor.run {
                    self.favorites = items
                }
            }
        }
    }
}
