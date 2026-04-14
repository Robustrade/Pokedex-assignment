//
//  FavouritesViewModelTests.swift
//  iosApp
//
//  Created by Akash K on 14/04/26.
//

import XCTest
import shared
@testable import iosApp


@MainActor
final class FavouritesViewModelTests: XCTestCase {

    private var repository: MockPokemonRepository!

    override func setUp() {
        super.setUp()
        repository = MockPokemonRepository()
    }

    func test_initialFavorites_isEmpty() async throws {
        let sut = FavouritesViewModel(repository: repository)
        XCTAssertTrue(sut.favorites.isEmpty)
    }

    func test_unfavourite_callsSetFavoriteWithFalse() async throws {
        let pokemon = Pokemon(id: 25, name: "pikachu", imageUrl: "")
        let sut = FavouritesViewModel(repository: repository)
        sut.unfavourite(pokemon)
        XCTAssertEqual(repository.setFavoriteCallCount, 1)
        XCTAssertEqual(repository.lastSetFavoriteArgs?.id, 25)
        XCTAssertEqual(repository.lastSetFavoriteArgs?.isFavorite, false)
    }
}
