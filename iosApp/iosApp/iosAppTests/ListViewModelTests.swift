//
//  ListViewModelTests.swift
//  iosApp
//
//  Created by Akash K on 14/04/26.
//

import XCTest
import shared
import Combine
@testable import iosApp


@MainActor
final class ListViewModelTests: XCTestCase {

    private var repository: MockPokemonRepository!
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        repository = MockPokemonRepository()
    }

    func test_initialState_isNotNil() {
        let sut = ListViewModel(repository: repository)
        XCTAssertNotNil(sut.listState)
    }

    func test_successState_afterPageLoads_containsPokemon() async {
        let pikachu = Pokemon(id: 25, name: "pikachu", imageUrl: "")
        repository.stubbedPage = PokemonPage(pokemon: [pikachu], hasMore: false)

        let sut = ListViewModel(repository: repository)

        sut.$listState
            .compactMap { $0 as? PokemonListState.Success }
            .sink { success in
                XCTAssertEqual(success.pokemon.count, 1)
                XCTAssertEqual(success.pokemon.first?.name, "pikachu")
            }
            .store(in: &cancellables)
    }

    func test_loadNextPage_callsRepositoryAgain() async {
        repository.stubbedPage = PokemonPage(pokemon: [], hasMore: true)
        let sut = ListViewModel(repository: repository)
        
        let callsBefore = repository.getPokemonPageCallCount
        sut.loadNextPage()
        sut.$listState
            .compactMap { $0 as? PokemonListState.Success }
            .sink { success in
                XCTAssertGreaterThan(self.repository.getPokemonPageCallCount, callsBefore)
            }
            .store(in: &cancellables)
    }

    func test_refresh_callsRepository() async throws {
        repository.stubbedPage = PokemonPage(pokemon: [], hasMore: false)
        let sut = ListViewModel(repository: repository)
        let callsBefore = repository.getPokemonPageCallCount
        sut.refresh()
        sut.$listState
            .compactMap { $0 as? PokemonListState.Success }
            .sink { success in
                XCTAssertGreaterThan(self.repository.getPokemonPageCallCount, callsBefore)
            }
            .store(in: &cancellables)
    }
}
