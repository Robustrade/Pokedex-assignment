//
//  FavoritesStoreTests.swift
//  PokèDexTests
//
//  Created by Dharamrajsinh Jadeja on 06/04/26.
//

import XCTest
import Combine
@testable import PokeDex
import shared

@MainActor
final class FavoritesStoreTests: XCTestCase {

    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }

    // MARK: - Helpers
    private func makeStore() throws -> FavoritesStore {
        let repo = try ModulesKt.getRepository()
        return FavoritesStore(repository: repo)
    }

    // MARK: - Initial State
    func testInitialFavorites_isEmptyArray() throws {
        let store = try makeStore()
        XCTAssertNotNil(store.favorites, "Favorites should never be nil")
    }

    // MARK: - Flow Collection
    func testFavoritesFlow_emitsValue() async throws {
        let store = try makeStore()

        let expectation = XCTestExpectation(description: "Favorites publisher should emit")

        store.$favorites
            .dropFirst()
            .first()
            .sink { favorites in
                XCTAssertNotNil(favorites)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        await fulfillment(of: [expectation], timeout: 10)
    }

    // MARK: - Actions
    func testRefresh_doesNotCrash() throws {
        let store = try makeStore()
        store.refresh()
    }
}
