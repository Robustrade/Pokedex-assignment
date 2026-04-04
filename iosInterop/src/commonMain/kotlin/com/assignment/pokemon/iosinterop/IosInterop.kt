package com.assignment.pokemon.iosinterop

import com.assignment.pokemon.data.repository.PokemonRepository
import org.koin.mp.KoinPlatform

/**
 * Resolves the [PokemonRepository] from Koin after [com.assignment.pokemon.di.initKoin] has run.
 *
 * This module lives outside `shared/` (see `iosInterop/`). It builds a **standalone** Kotlin
 * framework (`iosInterop.xcframework`) that embeds `shared`. Do **not** link that framework in the
 * same app as the separate `shared` CocoaPods framework—Kotlin/Native would duplicate runtime
 * symbols. For CocoaPods + `shared` pod, use the Swift helper in `PokemonRepositoryResolver.swift` instead.
 */
fun getPokemonRepository(): PokemonRepository =
    KoinPlatform.getKoin().get(PokemonRepository::class, null, null)
