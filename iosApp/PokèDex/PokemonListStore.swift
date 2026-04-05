//
//  PokemonListStore.swift
//  PokèDex
//
//  Created by Dharamrajsinh Jadeja on 04/04/26.
//


import shared
import Combine
import KMPNativeCoroutinesAsync
import OSLog

@MainActor
final class PokemonListStore: ObservableObject {
    @Published private(set) var state: PokemonListState = PokemonListState.Loading()
    
    private let viewModel: PokemonListViewModel
    
    private var task: Task<Void, Never>?
    
    init(repository: PokemonRepository) {
        viewModel = PokemonListViewModel(repository: repository)
        let stateFlow = viewModel.stateFlow
        task = Task { [weak self] in
            guard let self else {return}
            do {
                // Collect the KMP StateFlow using an AsyncStream bridge
                for try await newState in asyncSequence(for: stateFlow) {
                    state = newState
                }
            } catch {
                os_log("\(error.localizedDescription)")
                state = PokemonListState.Error(message: error.localizedDescription)
            }
        }
    }
    
    func loadNextPage() {
        viewModel.loadNextPage()
    }
    
    func search(_ query: String) {
        viewModel.search(query: query)
    }
    
    deinit {
        task?.cancel()
        viewModel.onCleared()
    }
}
