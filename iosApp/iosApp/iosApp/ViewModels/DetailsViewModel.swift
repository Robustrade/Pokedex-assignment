//
//  DetailsViewModel.swift
//  iosApp
//
//  Created by Akash K on 12/04/26.
//

import shared
import Combine

final class DetailsViewModel: ObservableObject {
    @Published private(set) var detailState: PokemonDetailState = .Loading()
    private let viewModel: PokemonDetailViewModel
    private var stateTask: Task<Void, Never>?

    init(name: String, repository: PokemonRepository) {
        viewModel = PokemonDetailViewModel(
            pokemonName: name,
            repository: repository
        )

        if let currentState = viewModel.state.value as? PokemonDetailState {
            detailState = currentState
        }

        observeState()
    }

    deinit {
        viewModel.onCleared()
        stateTask?.cancel()
    }

    func toggleFavourite() {
        viewModel.toggleFavorite()
    }

    func retry() {
        viewModel.retry()
    }

    private func observeState() {
        let stateFlow = viewModel.state

        stateTask = Task { [weak self] in
            for await state in stateFlow.stream(of: PokemonDetailState.self) {
                guard let self else { return }
                await MainActor.run {
                    self.detailState = state
                }
            }
        }
    }
}
