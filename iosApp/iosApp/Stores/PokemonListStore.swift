import Foundation
import Combine
import shared

@MainActor
final class PokemonListStore: ObservableObject {
    @Published private(set) var state: PokemonListState = PokemonListState.Loading.shared
    
    private let viewModel: PokemonListViewModel
    private var collectTask: Task<Void, Never>?
    
    init() {
        self.viewModel = PokemonListViewModel(repository: KoinHelper.shared.repository)
        startCollecting()
    }
    
    private func startCollecting() {
        collectTask = Task { [weak self] in
            guard let self = self else { return }
            for await newState in self.viewModel.state.stream() as AsyncStream<PokemonListState> {
                guard !Task.isCancelled else { break }
                self.state = newState
            }
        }
    }
    
    func loadNextPage() {
        viewModel.loadNextPage()
    }
    
    func search(_ query: String) {
        viewModel.search(query: query)
    }
    
    func refresh() {
        viewModel.refresh()
    }
    
    deinit {
        collectTask?.cancel()
        viewModel.onCleared()
    }
}

// MARK: - State Helper Extensions
extension PokemonListState {
    var isLoading: Bool {
        self is PokemonListState.Loading
    }
    
    var successState: PokemonListState.Success? {
        self as? PokemonListState.Success
    }
    
    var errorState: PokemonListState.Error? {
        self as? PokemonListState.Error
    }
}
