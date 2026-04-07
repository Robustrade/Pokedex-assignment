import shared

/// ObservableObject wrapper around the KMP `PokemonListViewModel`.
/// All pagination and  search logic lives here
@MainActor
final class PokemonListStore: ObservableObject {
    
    @Published private(set) var state: PokemonListState = PokemonListState.Loading()
    
    private static let loadMoreThreshold = 3
    
    private let viewModel: PokemonListViewModel
    
    init(repository: PokemonRepository = KoinDependencies.shared.repository) {
        viewModel = PokemonListViewModel(repository: repository)
        loadInitialState()
        observeState()
    }
    
    private func loadInitialState() {
        if let initial = viewModel.state.value as? PokemonListState {
            state = initial
        }
    }
    
    private func observeState() {
        viewModel.state.observe(as: PokemonListState.self) { [weak self] newState in
            self?.state = newState
        }
    }
    
    
    /// Triggers the next page load when approaching the end of the list.
    func onItemAppeared(index: Int, totalCount: Int, canLoadMore: Bool) {
        if index >= totalCount - Self.loadMoreThreshold && canLoadMore {
            viewModel.loadNextPage()
        }
    }
    
    func search(_ query: String) { viewModel.search(query: query) }
    func refresh() { viewModel.refresh() }
    
    deinit { viewModel.onCleared() }
}
