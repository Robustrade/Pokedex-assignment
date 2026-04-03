import Foundation
import shared

/// ObservableObject wrapper around the KMP `PokemonDetailViewModel`.
/// All presentation / formatting logic lives here — views only read & render.
@MainActor
final class PokemonDetailStore: ObservableObject {
    
    @Published private(set) var state: PokemonDetailState = PokemonDetailState.Loading()
    
    private let viewModel: PokemonDetailViewModel
    
    init(pokemonName: String, repository: PokemonRepository = KoinDependencies.shared.repository) {
        viewModel = PokemonDetailViewModel(pokemonName: pokemonName,repository: repository)
        loadInitialState()
        observeState()
    }
    
    
    private func loadInitialState() {
        if let initial = viewModel.state.value as? PokemonDetailState {
            state = initial
        }
    }
    
    private func observeState() {
        viewModel.state.observe(as: PokemonDetailState.self) { [weak self] newState in
            self?.state = newState
        }
    }
    
    
    func toggleFavorite() { viewModel.toggleFavorite() }
    func retry() { viewModel.retry() }
    
    func formattedId(_ id: Int32) -> String {
        PokemonFormatter.formattedId(id)
    }
    
    func formattedHeight(_ raw: Int32) -> String {
        String(format: "%.1f m", Double(raw) / 10.0)
    }
    
    func formattedWeight(_ raw: Int32) -> String {
        String(format: "%.1f kg", Double(raw) / 10.0)
    }
    
    func shortStatName(_ name: String) -> String {
        switch name.lowercased() {
        case "hp":              return "HP"
        case "attack":          return name
        case "defense":         return name
        case "special-attack":  return "Sp. Attack"
        case "special-defense": return "Sp. Defence"
        case "speed":           return name
        default:                return String(name.prefix(3)).uppercased()
        }
    }
    
    func formattedAbility(_ ability: String) -> String {
        ability.replacingOccurrences(of: "-", with: " ").capitalized
    }
    
    deinit { viewModel.onCleared() }
}
