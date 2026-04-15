import Foundation
import shared

/// Swift-side helper to access KMP Koin dependencies.
///
/// Usage:
/// ```swift
/// let repository = KoinHelper.shared.repository
/// let viewModel = PokemonListViewModel(repository: repository)
/// ```
final class KoinHelper {
    static let shared = KoinHelper()
    
    private var _repository: PokemonRepository?
    
    private init() {}
    
    /// The shared PokemonRepository instance from Koin.
    /// Lazily resolved on first access.
    var repository: PokemonRepository {
        if _repository == nil {
            _repository = KoinIOSKt.getRepository()
        }
        return _repository!
    }
}
