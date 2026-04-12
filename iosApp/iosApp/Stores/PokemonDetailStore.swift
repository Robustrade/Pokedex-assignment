import shared
import Combine

/// ObservableObject wrapper around the KMP `PokemonDetailViewModel`.
/// Bridges `StateFlow<PokemonDetailState>` into SwiftUI's `@Published`.
@MainActor
final class PokemonDetailStore: ObservableObject {

    @Published private(set) var state: PokemonDetailState = PokemonDetailState.Loading()

    private let viewModel: PokemonDetailViewModel
    private var collectTask: Task<Void, Never>?

    init(pokemonName: String, repository: PokemonRepository) {
        viewModel = PokemonDetailViewModel(
            pokemonName: pokemonName,
            repository: repository
        )
        startCollecting()
    }

    // MARK: - Public API

    func toggleFavorite() {
        viewModel.toggleFavorite()
    }

    func retry() {
        viewModel.retry()
    }

    // MARK: - Private

    private func startCollecting() {
        collectTask = Task { [weak self] in
            guard let self else { return }
            do {
                try await self.viewModel.state.collect(
                    collector: SwiftFlowCollector { [weak self] value in
                        guard let newState = value as? PokemonDetailState else { return }
                        Task { @MainActor [weak self] in
                            self?.state = newState
                        }
                    }
                )
            } catch {
                // Flow collection cancelled
            }
        }
    }

    deinit {
        collectTask?.cancel()
        viewModel.onCleared()
    }
}
