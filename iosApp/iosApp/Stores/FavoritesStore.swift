import shared
import Combine

/// ObservableObject wrapper around the KMP `FavoritesViewModel`.
/// Bridges `StateFlow<List<Pokemon>>` into SwiftUI's `@Published`.
@MainActor
final class FavoritesStore: ObservableObject {

    @Published private(set) var favorites: [Pokemon] = []

    private let viewModel: FavoritesViewModel
    private var collectTask: Task<Void, Never>?

    init(repository: PokemonRepository) {
        viewModel = FavoritesViewModel(repository: repository)
        startCollecting()
    }

    // MARK: - Private

    private func startCollecting() {
        collectTask = Task { [weak self] in
            guard let self else { return }
            do {
                try await self.viewModel.favorites.collect(
                    collector: SwiftFlowCollector { [weak self] value in
                        guard let list = value as? [Pokemon] else { return }
                        Task { @MainActor [weak self] in
                            self?.favorites = list
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
