import Foundation
import Combine
import shared

@MainActor
final class FavoritesStore: ObservableObject {
    @Published private(set) var favorites: [Pokemon] = []
    
    private let viewModel: FavoritesViewModel
    private var collectTask: Task<Void, Never>?
    
    init() {
        self.viewModel = FavoritesViewModel(repository: KoinHelper.shared.repository)
        startCollecting()
    }
    
    private func startCollecting() {
        collectTask = Task { [weak self] in
            guard let self = self else { return }
            for await newFavorites in self.viewModel.favorites.stream() as AsyncStream<[Pokemon]> {
                guard !Task.isCancelled else { break }
                self.favorites = newFavorites
            }
        }
    }
    
    deinit {
        collectTask?.cancel()
        viewModel.onCleared()
    }
}
