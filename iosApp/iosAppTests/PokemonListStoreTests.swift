import XCTest
@testable import iosApp
import shared

/// Unit tests for the SwiftUI store/wrapper layer.
/// These validate that the Store correctly bridges KMP ViewModel state.
final class PokemonListStoreTests: XCTestCase {

    private static var isKoinStarted = false
    
    override func setUp() async throws {
        try await super.setUp()
        await MainActor.run {
            if !Self.isKoinStarted {
                KoinHelper.start()
                Self.isKoinStarted = true
            }
        }
    }

    /// Verify the store initialises with a Loading state.
    @MainActor
    func testInitialStateIsLoading() async {
        // The store should start in Loading state before the ViewModel
        // fetches its first page.
        let store = PokemonListStore(repository: KoinHelper.getRepository())

        // Initial published state must be Loading
        XCTAssertTrue(store.state is PokemonListState.Loading,
                      "Expected initial state to be Loading, got \(type(of: store.state))")
    }

    /// Verify search updates state without crashing.
    @MainActor
    func testSearchDoesNotCrash() async {
        let store = PokemonListStore(repository: KoinHelper.getRepository())
        store.search("pikachu")

        // If we get here without a crash, the test passes.
        // The search filters are applied client-side so no network call is needed.
    }
}
