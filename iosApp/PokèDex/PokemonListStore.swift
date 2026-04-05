//
//  PokemonListStore.swift
//  PokèDex
//
//  Created by Dharamrajsinh Jadeja on 04/04/26.
//


import shared
import Combine
import KMPNativeCoroutinesAsync

@MainActor
final class PokemonListStore: ObservableObject {
    @Published private(set) var state: PokemonListState =
    PokemonListState.Loading()
    private let viewModel: PokemonListViewModel
    private var task: Task<Void, Never>?
    init(repository: PokemonRepository) {
        viewModel = PokemonListViewModel(repository: repository)
//        task = Task {
//            // Collect the KMP StateFlow using an AsyncStream bridge
//            for try await newState in asyncSequence(for: viewModel.stateFlow) {
//                self.state = newState
//            }
//        }
    }
    func loadNextPage() { viewModel.loadNextPage() }
    func search(_ query: String) { viewModel.search(query: query) }
    deinit {
        task?.cancel()
        viewModel.onCleared()
    }
}
