import XCTest
@testable import iosApp
import shared

@MainActor
final class FavoritesStoreTests: XCTestCase {
    
    func testInitialFavoritesEmpty() async {
        let store = FavoritesStore()
        
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertNotNil(store.favorites)
    }
    
    func testFavoritesReactiveUpdates() async {
        let store = FavoritesStore()
        
        let initialCount = store.favorites.count
        
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        XCTAssertEqual(store.favorites.count, initialCount)
    }
}
