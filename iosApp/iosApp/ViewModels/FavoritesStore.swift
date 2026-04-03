import shared

/// ObservableObject wrapper around the KMP `FavoritesViewModel`.
/// Publishes a live list of favourite Pokémon backed by the local database.
///
@MainActor
final class FavoritesStore: ObservableObject {
    
    @Published private(set) var favorites: [Pokemon] = []
    
    private let viewModel: FavoritesViewModel
    
    init(repository: PokemonRepository = KoinDependencies.shared.repository) {
        viewModel = FavoritesViewModel(repository: repository)
        loadFavorites()
        observeFavorites()
    }
    
    private func loadFavorites() {
        if let fav = viewModel.favorites.value as? [Pokemon] {
            favorites = fav
        }
    }
    
    private func observeFavorites() {
        viewModel.favorites.observe(as: [Pokemon].self) { [weak self] list in
            self?.favorites = list
        }
    }
    
    deinit {
        viewModel.onCleared()
    }
}
