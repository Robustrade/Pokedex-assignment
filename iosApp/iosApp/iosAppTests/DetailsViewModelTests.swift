//
//  DetailsViewModelTests.swift
//  iosApp
//
//  Created by Akash K on 14/04/26.
//

import XCTest
import shared
@testable import iosApp
import Combine

@MainActor
final class DetailsViewModelTests: XCTestCase {

    private var repository: MockPokemonRepository!
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        repository = MockPokemonRepository()
    }

    func test_initialState_isNotNil() {
        let sut = DetailsViewModel(name: "pikachu", repository: repository)
        XCTAssertNotNil(sut.detailState)
    }

    func test_toggleFavourite_callsSetFavorite() async {
        let sut = DetailsViewModel(name: "pikachu", repository: repository)
        sut.toggleFavourite()
        sut.$detailState
            .compactMap { $0 as? PokemonDetailState.Success }
            .sink { _ in
                XCTAssert(self.repository.setFavoriteCallCount > 0)
            }
            .store(in: &cancellables)
    }

    func test_retry_callsRepositoryAgain() {
        let sut = DetailsViewModel(name: "pikachu", repository: repository)
        let callsBefore = repository.getPokemonDetailCallCount
        sut.retry()
        sut.$detailState
            .compactMap { $0 as? PokemonDetailState.Success }
            .sink { _ in
                XCTAssertGreaterThan(self.repository.getPokemonDetailCallCount, callsBefore)
            }
            .store(in: &cancellables)
    }
}
