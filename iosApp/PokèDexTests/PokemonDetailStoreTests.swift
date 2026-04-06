//
//  PokemonDetailStoreTests.swift
//  PokèDexTests
//
//  Created by Dharamrajsinh Jadeja on 06/04/26.
//

import XCTest
import Combine
@testable import PokeDex
import shared

@MainActor
final class PokemonDetailStoreTests: XCTestCase {

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
    private func makeStore(name: String = "bulbasaur") throws -> PokemonDetailStore {
        let repo = try ModulesKt.getRepository()
        return PokemonDetailStore(name: name, repository: repo)
    }

    private func awaitFirstState(
        _ store: PokemonDetailStore,
        timeout: TimeInterval = 15
    ) async throws -> PokemonDetailState {
        let expectation = XCTestExpectation(description: "State should leave Loading")
        var result: PokemonDetailState?

        store.$state
            .filter { !($0 is PokemonDetailState.Loading) }
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
        XCTAssertTrue(store.state is PokemonDetailState.Loading)
    }

    // MARK: - Success
    func testDetail_loadsCorrectPokemon() async throws {
        let store = try makeStore(name: "bulbasaur")

        let state = try await awaitFirstState(store)

        guard let success = state as? PokemonDetailState.Success else {
            try XCTSkipIf(state is PokemonDetailState.Error, "Skipping: API returned error")
            return
        }

        XCTAssertEqual(success.pokemon.name, "bulbasaur")
        XCTAssertFalse(success.pokemon.types.isEmpty, "Should have at least one type")
        XCTAssertFalse(success.pokemon.stats.isEmpty, "Should have base stats")
        XCTAssertFalse(success.pokemon.abilities.isEmpty, "Should have abilities")
        XCTAssertGreaterThan(success.pokemon.height, 0)
        XCTAssertGreaterThan(success.pokemon.weight, 0)
    }

    // MARK: - Error
    func testDetail_invalidPokemon_returnsError() async throws {
        let store = try makeStore(name: "not_a_real_pokemon_xyz_999")

        let state = try await awaitFirstState(store)

        XCTAssertTrue(state is PokemonDetailState.Error, "Invalid name should produce Error state")
    }

    // MARK: - Actions
    func testToggleFavorite_afterLoad_doesNotCrash() async throws {
        let store = try makeStore(name: "bulbasaur")

        let state = try await awaitFirstState(store)

        guard state is PokemonDetailState.Success else {
            try XCTSkipIf(state is PokemonDetailState.Error, "Skipping: API returned error")
            return
        }

        // Toggle on, then toggle off — verify no crash
        store.toggleFavorite()
        store.toggleFavorite()
    }

    func testRetry_doesNotCrash() throws {
        let store = try makeStore()
        store.retry()
    }
}
