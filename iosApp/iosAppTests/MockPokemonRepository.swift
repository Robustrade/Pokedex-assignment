import Foundation
import shared

/// Minimal test double for `PokemonRepository` so `*ScreenModel` wrappers can be unit-tested without Koin or network.
final class MockPokemonRepository: NSObject, PokemonRepository {
    func getPokemonDetail(name: String, completionHandler: @escaping (Any?, Error?) -> Void) {
        let detail = PokemonDetail(
            id: 25,
            name: name,
            imageUrl: "",
            height: 4,
            weight: 60,
            types: ["electric"],
            stats: [PokemonStat(name: "hp", value: 35)],
            abilities: ["static"],
            isFavorite: false
        )
        completionHandler(detail, nil)
    }

    func getPokemonPage(limit: Int32, offset: Int32, completionHandler: @escaping (Any?, Error?) -> Void) {
        let page = PokemonPage(pokemon: [], hasMore: false)
        completionHandler(page, nil)
    }

    func observeFavorites() -> any Kotlinx_coroutines_coreFlow {
        EmptyFavoritesFlow()
    }

    func setFavorite(id: Int32, name: String, imageUrl: String, isFavorite: Bool, completionHandler: @escaping (Error?) -> Void) {
        completionHandler(nil)
    }
}

private final class EmptyFavoritesFlow: NSObject, Kotlinx_coroutines_coreFlow {
    func collect(collector: Kotlinx_coroutines_coreFlowCollector, completionHandler: @escaping (Error?) -> Void) {
        collector.emit(value: NSArray(), completionHandler: { err in
            completionHandler(err)
        })
    }
}
