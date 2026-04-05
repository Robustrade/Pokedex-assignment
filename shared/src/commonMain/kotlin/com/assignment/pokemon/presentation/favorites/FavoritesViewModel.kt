package com.assignment.pokemon.presentation.favorites

import com.assignment.pokemon.data.model.Pokemon
import com.assignment.pokemon.data.repository.PokemonRepository
import com.assignment.pokemon.presentation.base.BaseViewModel
import com.rickclephas.kmp.nativecoroutines.NativeCoroutinesState
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.stateIn

class FavoritesViewModel(
    repository: PokemonRepository,
) : BaseViewModel() {

    /**
     * Live stream of favorite Pokemon from the local database.
     * Automatically emits whenever a favorite is added or removed.
     */
    @NativeCoroutinesState
    val favorites: StateFlow<List<Pokemon>> = repository
        .observeFavorites()
        .stateIn(
            scope = viewModelScope,
            started = SharingStarted.WhileSubscribed(stopTimeoutMillis = 5_000),
            initialValue = emptyList(),
        )
}
