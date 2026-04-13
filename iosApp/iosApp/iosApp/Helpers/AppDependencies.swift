//
//  AppDependencies.swift
//  iosApp
//
//  Created by Akash K on 12/04/26.
//

import shared
import SwiftUI

protocol ViewModelFactory {
    func makeListViewModel() -> ListViewModel
    func makeDetailsViewModel(name: String) -> DetailsViewModel
    func makeFavouritesViewModel() -> FavouritesViewModel
}

final class AppDependencies: ViewModelFactory {
    private let repository: PokemonRepository

    init(koinDependencyManager: KoinDependencyManager = .shared) {
        self.repository = koinDependencyManager.repository
    }

    func makeListViewModel() -> ListViewModel {
        ListViewModel(repository: repository)
    }

    func makeDetailsViewModel(name: String) -> DetailsViewModel {
        DetailsViewModel(name: name, repository: repository)
    }
    
    func makeFavouritesViewModel() -> FavouritesViewModel {
        FavouritesViewModel(repository: repository)
    }
}

private final class DefaultViewModelFactory: ViewModelFactory {
    func makeListViewModel() -> ListViewModel {
        fatalError("ViewModelFactory not configured in Environment")
    }

    func makeDetailsViewModel(name: String) -> DetailsViewModel {
        fatalError("ViewModelFactory not configured in Environment")
    }
    
    func makeFavouritesViewModel() -> FavouritesViewModel {
        fatalError("ViewModelFactory not configured in Environment")
    }
}

private struct ViewModelFactoryKey: EnvironmentKey {
    static let defaultValue: ViewModelFactory = DefaultViewModelFactory()
}

extension EnvironmentValues {
    var viewModelFactory: ViewModelFactory {
        get { self[ViewModelFactoryKey.self] }
        set { self[ViewModelFactoryKey.self] = newValue }
    }
}
