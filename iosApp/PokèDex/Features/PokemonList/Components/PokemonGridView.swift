//
//  PokemonGridView.swift
//  PokèDex
//
//  Created by Dharamrajsinh Jadeja on 05/04/26.
//
import SwiftUI
import shared

struct PokemonGridView: View {
    let state: PokemonListState
    let columns: [GridItem]
    let store: PokemonListStore
    
    var body: some View {
        Group {
            switch state {
            case is PokemonListState.Loading:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            case let success as PokemonListState.Success:
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(success.pokemon, id: \.id) { poke in
                            NavigationLink(value: poke.name) {
                                PokemonGridCard(pokemon: poke)
                            }
                            
                            // Trigger load more near the end
                            if success.pokemon.last?.id == poke.id && success.canLoadMore {
                                Color.clear
                                    .onAppear {
                                        store.loadNextPage()
                                    }
                            }
                        }
                    }
                    .padding()
                }
            
            case let error as PokemonListState.Error:
                ErrorView(message: error.message)
            
            default:
                EmptyView()
            }
        }
    }
}
