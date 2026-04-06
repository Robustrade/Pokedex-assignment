//
//  PokemonListStoreTests.swift
//  PokèDexTests
//
//  Created by Dharamrajsinh Jadeja on 06/04/26.
//

import XCTest
import Combine
@testable import PokeDex
import shared

/// Integration tests for PokemonListStore.
///
/// These verify the SwiftUI wrapper correctly bridges KMP StateFlow → @Published.
/// PokemonRepository is a Kotlin interface with suspend/Flow members that can't
/// be mocked from Swift, so we test against the real Koin graph.
@MainActor
final class PokemonListStoreTests: XCTestCase {

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

    private func makeStore() throws -> PokemonListStore {
        let repo = try ModulesKt.getRepository()
        return PokemonListStore(repository: repo)
    }

    /// Waits for the store's state to leave Loading and returns the first non-Loading state.
    private func awaitFirstState(
        _ store: PokemonListStore,
        timeout: TimeInterval = 15
    ) async throws -> PokemonListState {
        let expectation = XCTestExpectation(description: "State should leave Loading")
        var result: PokemonListState?

        store.$state
            .filter { !($0 is PokemonListState.Loading) }
            .first()
            .sink { state in
                result = state
                expectation.fulfill()
            }
            .store(in: &cancellables)

        await fulfillment(of: [expectation], timeout: timeout)
        return try XCTUnwrap(result, "State never left Loading")
    }

    // MARK: - Initial State

    func testInitialState_isLoading() throws {
        let store = try makeStore()
        XCTAssertTrue(store.state is PokemonListState.Loading)
    }

    // MARK: - State Collection

    func testStateFlow_transitionsFromLoading() async throws {
        let store = try makeStore()

        let state = try await awaitFirstState(store)

        XCTAssertTrue(
            state is PokemonListState.Success || state is PokemonListState.Error,
            "Expected Success or Error after loading, got \(type(of: state))"
        )
    }

    func testSuccessState_containsPokemon() async throws {
        let store = try makeStore()

        let state = try await awaitFirstState(store)

        guard let success = state as? PokemonListState.Success else {
            // Network may be down in CI — don't fail, just skip
            try XCTSkipIf(state is PokemonListState.Error, "Skipping: API returned error")
            return
        }
        XCTAssertFalse(success.pokemon.isEmpty, "First page should contain pokemon")
        XCTAssertTrue(success.canLoadMore, "First page should allow loading more")
    }

    // MARK: - Actions

    func testSearch_doesNotCrash() throws {
        let store = try makeStore()
        store.search("pikachu")
        store.search("")
    }

    func testLoadNextPage_doesNotCrash() throws {
        let store = try makeStore()
        store.loadNextPage()
    }

    func testRefresh_doesNotCrash() throws {
        let store = try makeStore()
        store.refresh()
    }
}
