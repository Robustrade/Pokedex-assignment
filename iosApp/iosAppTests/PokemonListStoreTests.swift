import XCTest
@testable import iosApp
import shared

@MainActor
final class PokemonListStoreTests: XCTestCase {
    
    func testInitialState() async {
        let store = PokemonListStore()
        
        let initialState = store.state
        XCTAssertTrue(initialState is PokemonListStateLoading)
    }
    
    func testSearchUpdatesState() async {
        let store = PokemonListStore()
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        store.search("pikachu")
        
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        if case let success as PokemonListStateSuccess = store.state {
            let filteredPokemon = success.pokemon
            for pokemon in filteredPokemon {
                XCTAssertTrue(pokemon.name.lowercased().contains("pikachu"))
            }
        }
    }
}
