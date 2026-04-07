//
//  PokemonGrid.swift
//  iosApp
//
//  Created by vishwas on 4/3/26.
//

import SwiftUI
import shared

struct PokemonGridView: View {
    let success: PokemonListState.Success
    let columns: [GridItem]
    let store: PokemonListStore
    
    var body: some View {
        let pokemonList = success.pokemon
        
        if pokemonList.isEmpty {
            PokemonEmptyStateView()
        } else {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(Array(pokemonList.enumerated()), id: \.element.id) { index, pokemon in
                        NavigationLink(value: pokemon.name) {
                            PokemonGridCell(pokemon: pokemon)
                        }
                        .buttonStyle(.plain)
                        .onAppear {
                            store.onItemAppeared(
                                index: index,
                                totalCount: pokemonList.count,
                                canLoadMore: success.canLoadMore
                            )
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, 8)
                
                if success.isLoadingMore {
                    ProgressView()
                        .padding(.vertical, 16)
                }
            }
            .refreshable { store.refresh() }
        }
    }
}
