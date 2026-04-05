//
//  PokemonListStore.swift
//  PokèDex
//
//  Created by Dharamrajsinh Jadeja on 04/04/26.
//

import Foundation
import Combine
import shared
import KMPNativeCoroutinesAsync

/// ViewModel for Pokemon List feature. Bridges KMP ViewModel with SwiftUI
@MainActor
final class PokemonListStore: ObservableObject {
    @Published private(set) var state: PokemonListState = PokemonListState.Loading()
    
    private let viewModel: PokemonListViewModel
    private var task: Task<Void, Never>?
    
    init(repository: PokemonRepository) {
        self.viewModel = PokemonListViewModel(repository: repository)
        
        task = Task { [weak self] in
            guard let self else { return }
            do {
                // Use asyncSequence(for:) from KMPNativeCoroutinesAsync to collect the StateFlow
                // StateFlow<T> is directly exposed as a property on the ViewModel
                for try await newState in asyncSequence(for: viewModel.stateFlow) {
                    self.state = newState
                }
            } catch {
                print("Error collecting Pokemon state: \(error)")
                state = PokemonListState.Error(message: error.localizedDescription)
            }
        }
    }
    
    func refresh() {
        viewModel.refresh()
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
