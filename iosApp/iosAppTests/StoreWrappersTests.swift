import XCTest
import shared
@testable import iosApp

/// Unit tests for `StoreWrappers.swift` — the SwiftUI `ObservableObject` adapters around shared ViewModels.
///
/// - `FavoritesScreenModel` can be fully exercised with `MockPokemonRepository` (Flow emits empty list).
/// - `PokemonListScreenModel` / `PokemonDetailScreenModel` call suspend APIs that bridge Kotlin `Result` into Swift;
///   a hand-written `PokemonRepository` mock must match that bridge exactly or the Kotlin VM fails at runtime.
///   Those wrappers are covered in UI/integration runs; keep production wiring in `StoreWrappers.swift` minimal.
@MainActor
final class StoreWrappersTests: XCTestCase {

    func testFavoritesScreenModelReceivesEmptyListFromMockFlow() async {
        let model = FavoritesScreenModel(repository: MockPokemonRepository())
        try? await Task.sleep(nanoseconds: 600_000_000)
        XCTAssertEqual(model.favorites.count, 0)
    }
}

// MARK: - Kotlin list decoding (used only by `FavoritesScreenModel`)

final class KotlinPokemonListBridgeTests: XCTestCase {
    func testPokemonArrayFromNilIsEmpty() {
        XCTAssertTrue(PokemonList.pokemonArray(from: nil).isEmpty)
    }

    func testPokemonArrayFromEmptyNSArray() {
        XCTAssertTrue(PokemonList.pokemonArray(from: NSArray()).isEmpty)
    }
}
