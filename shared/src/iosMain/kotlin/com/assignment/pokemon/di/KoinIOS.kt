package com.assignment.pokemon.di

import com.assignment.pokemon.data.repository.PokemonRepository
import org.koin.core.component.KoinComponent
import org.koin.core.component.get

/**
 * iOS-specific Koin helper to expose dependencies to Swift.
 * This is necessary because Koin's internals are not directly accessible from Swift.
 */
object KoinIOS : KoinComponent {
    fun getRepository(): PokemonRepository = get()
}

/**
 * Helper function for Swift to get the repository.
 */
fun getRepository(): PokemonRepository = KoinIOS.getRepository()
