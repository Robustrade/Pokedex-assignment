//
//  ListViewModel.swift
//  iosApp
//
//  Created by Akash K on 12/04/26.
//

import shared
import Combine

final class ListViewModel: ObservableObject {

    @MainActor @Published private(set) var listState: PokemonListState = .Loading()
    private let viewModel: PokemonListViewModel
    private var stateTask: Task<Void, Never>?

    init(repository: PokemonRepository = KoinDependencyManager.shared.repository) {
        self.viewModel = PokemonListViewModel(repository: repository)

        if let currentState = viewModel.state.value as? PokemonListState {
            listState = currentState
        }

        observeState()
    }

    deinit {
        stateTask?.cancel()
        viewModel.onCleared()
    }

    func refresh() {
        viewModel.refresh()
    }

    func loadNextPage() {
        viewModel.loadNextPage()
    }

    private func observeState() {
        let stateFlow = viewModel.state

        stateTask = Task { [weak self] in
            for await state in stateFlow.stream(of: PokemonListState.self) {
                guard let self else { return }
                self.listState = state
            }
        }
    }
}
