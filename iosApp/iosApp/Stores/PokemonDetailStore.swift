import Foundation
import Combine
import shared

@MainActor
final class PokemonDetailStore: ObservableObject {
    @Published private(set) var state: PokemonDetailState = PokemonDetailState.Loading.shared
    
    private let viewModel: PokemonDetailViewModel
    private var collectTask: Task<Void, Never>?
    
    init(pokemonName: String) {
        self.viewModel = PokemonDetailViewModel(
            pokemonName: pokemonName,
            repository: KoinHelper.shared.repository
        )
        startCollecting()
    }
    
    private func startCollecting() {
        collectTask = Task { [weak self] in
            guard let self = self else { return }
            for await newState in self.viewModel.state.stream() as AsyncStream<PokemonDetailState> {
                guard !Task.isCancelled else { break }
                self.state = newState
            }
        }
    }
    
    func toggleFavorite() {
        viewModel.toggleFavorite()
    }
    
    func retry() {
        viewModel.retry()
    }
    
    deinit {
        collectTask?.cancel()
        viewModel.onCleared()
    }
}

// MARK: - State Helper Extensions
extension PokemonDetailState {
    var isLoading: Bool {
        self is PokemonDetailState.Loading
    }
    
    var successState: PokemonDetailState.Success? {
        self as? PokemonDetailState.Success
    }
    
    var errorState: PokemonDetailState.Error? {
        self as? PokemonDetailState.Error
    }
}
