import shared
import Combine

/// ObservableObject wrapper around the KMP `PokemonListViewModel`.
/// Bridges `StateFlow<PokemonListState>` into SwiftUI's `@Published`.
@MainActor
final class PokemonListStore: ObservableObject {

    @Published private(set) var state: PokemonListState = PokemonListState.Loading()

    private let viewModel: PokemonListViewModel
    private var collectTask: Task<Void, Never>?

    init(repository: PokemonRepository) {
        viewModel = PokemonListViewModel(repository: repository)
        startCollecting()
    }

    // MARK: - Public API

    func loadNextPage() {
        viewModel.loadNextPage()
    }

    func search(_ query: String) {
        viewModel.search(query: query)
    }

    func refresh() {
        viewModel.refresh()
    }

    // MARK: - Private

    private func startCollecting() {
        collectTask = Task { [weak self] in
            guard let self else { return }
            do {
                try await self.viewModel.state.collect(
                    collector: SwiftFlowCollector { [weak self] value in
                        guard let newState = value as? PokemonListState else { return }
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
