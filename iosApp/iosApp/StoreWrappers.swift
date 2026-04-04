import Combine
import SwiftUI
import shared

// MARK: - SwiftUI ↔ shared ViewModels (ObservableObject bridges Kotlin StateFlow / Flow)

/// Bridges `PokemonListViewModel.state` into `@Published` SwiftUI state.
@MainActor
final class PokemonListScreenModel: ObservableObject {
    @Published private(set) var state: PokemonListState = PokemonListState.Loading()
    @Published var searchText = ""
    @Published var isGrid = false

    private let viewModel: PokemonListViewModel
    private var task: Task<Void, Never>?

    init(repository: PokemonRepository) {
        viewModel = PokemonListViewModel(repository: repository)

        task = Task { [weak self] in
            guard let self else { return }
            let stream = AsyncStream<PokemonListState> { continuation in
                let collector = FlowCollectorHelper { value in
                    if let state = value as? PokemonListState {
                        continuation.yield(state)
                    }
                }
                self.viewModel.state.collect(collector: collector) { _ in
                    continuation.finish()
                }
            }

            for await newState in stream {
                self.state = newState
            }
        }
    }

    func loadNextPage() { viewModel.loadNextPage() }
    func refresh() { viewModel.refresh() }
    func search(_ query: String) { viewModel.search(query: query) }

    func toggleGridLayout() {
        isGrid.toggle()
    }

    /// Call from list/grid `onAppear` when the last item becomes visible.
    func loadMoreIfAtEnd(success: PokemonListState.Success, index: Int) {
        guard success.canLoadMore, !success.isLoadingMore else { return }
        guard index == success.pokemon.count - 1 else { return }
        loadNextPage()
    }

    deinit {
        task?.cancel()
        viewModel.onCleared()
    }
}

/// Bridges `PokemonDetailViewModel.state` into `@Published` SwiftUI state.
@MainActor
final class PokemonDetailScreenModel: ObservableObject {
    @Published private(set) var state: PokemonDetailState = PokemonDetailState.Loading()

    private let viewModel: PokemonDetailViewModel
    private var task: Task<Void, Never>?

    init(pokemonName: String, repository: PokemonRepository) {
        viewModel = PokemonDetailViewModel(pokemonName: pokemonName, repository: repository)

        task = Task { [weak self] in
            guard let self else { return }
            let stream = AsyncStream<PokemonDetailState> { continuation in
                let collector = FlowCollectorHelper { value in
                    if let s = value as? PokemonDetailState {
                        continuation.yield(s)
                    }
                }
                self.viewModel.state.collect(collector: collector) { _ in
                    continuation.finish()
                }
            }

            for await newState in stream {
                self.state = newState
            }
        }
    }

    func retry() { viewModel.retry() }
    func toggleFavorite() { viewModel.toggleFavorite() }

    /// Navigation bar title derived from current state.
    var navigationTitle: String {
        if let success = state as? PokemonDetailState.Success {
            return success.pokemon.name.capitalized
        }
        return "Pokémon"
    }

    deinit {
        task?.cancel()
        viewModel.onCleared()
    }
}

/// Bridges `FavoritesViewModel.favorites` into `@Published` SwiftUI state.
@MainActor
final class FavoritesScreenModel: ObservableObject {
    @Published private(set) var favorites: [Pokemon] = []

    private let viewModel: FavoritesViewModel
    private var task: Task<Void, Never>?

    init(repository: PokemonRepository) {
        viewModel = FavoritesViewModel(repository: repository)

        task = Task { [weak self] in
            guard let self else { return }
            let stream = AsyncStream<[Pokemon]> { continuation in
                let collector = FlowCollectorHelper { value in
                    continuation.yield(PokemonList.pokemonArray(from: value))
                }
                self.viewModel.favorites.collect(collector: collector) { _ in
                    continuation.finish()
                }
            }

            for await list in stream {
                self.favorites = list
            }
        }
    }

    deinit {
        task?.cancel()
        viewModel.onCleared()
    }
}
