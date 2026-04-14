//
//  MockPokemonRepository.swift
//  iosAppTests
//
//  Created by Akash K on 14/04/26.
//

import Foundation
import shared

final class MockPokemonRepository: NSObject, PokemonRepository {

    // MARK: - Configurable stubs

    var stubbedPage: PokemonPage = PokemonPage(pokemon: [], hasMore: false)
    var stubbedDetail: PokemonDetail = PokemonDetail(
        id: 25,
        name: "pikachu",
        imageUrl: "https://example.com/pikachu.png",
        height: 4,
        weight: 60,
        types: ["electric"],
        stats: [PokemonStat(name: "hp", value: 35)],
        abilities: ["static"],
        isFavorite: false
    )
    var stubbedPageError: Error?
    var stubbedDetailError: Error?

    // helper counters
    private(set) var getPokemonPageCallCount = 0
    private(set) var getPokemonDetailCallCount = 0
    private(set) var setFavoriteCallCount = 0
    private(set) var lastSetFavoriteArgs: (id: Int32, isFavorite: Bool)?

    // MARK: - PokemonRepository conformance

    func getPokemonPage(
        limit: Int32,
        offset: Int32,
        completionHandler: @escaping (Any?, Error?) -> Void
    ) {
        getPokemonPageCallCount += 1
        if let error = stubbedPageError {
            completionHandler(nil, error)
        } else {
            completionHandler(stubbedPage, nil)
        }
    }

    func getPokemonDetail(
        name: String,
        completionHandler: @escaping (Any?, Error?) -> Void
    ) {
        getPokemonDetailCallCount += 1
        if let error = stubbedDetailError {
            completionHandler(nil, error)
        } else {
            completionHandler(stubbedDetail, nil)
        }
    }

    func observeFavorites() -> Kotlinx_coroutines_coreFlow {
        MockEmptyFavoritesFlow()
    }

    func setFavorite(
        id: Int32,
        name: String,
        imageUrl: String,
        isFavorite: Bool,
        completionHandler: @escaping (Error?) -> Void
    ) {
        setFavoriteCallCount += 1
        lastSetFavoriteArgs = (id: id, isFavorite: isFavorite)
        completionHandler(nil)
    }
}

// MARK: - Minimal Flow that emits one empty array and completes

private final class MockEmptyFavoritesFlow: NSObject, Kotlinx_coroutines_coreFlow {
    func collect(
        collector: Kotlinx_coroutines_coreFlowCollector,
        completionHandler: @escaping (Error?) -> Void
    ) {
        collector.emit(value: [] as NSArray) { error in
            completionHandler(error)
        }
    }
}
