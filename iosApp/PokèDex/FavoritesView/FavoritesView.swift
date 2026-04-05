//
//  FavoritesView.swift
//  PokèDex
//
//  Created by Dharamrajsinh Jadeja on 05/04/26.
//


import SwiftUI
import shared

struct FavoritesView: View {
    let repository: PokemonRepository
    
    @StateObject private var store: FavoritesStore
    @State private var selectedPokemon: String?
    
    init(repository: PokemonRepository) {
        self.repository = repository
        _store = StateObject(wrappedValue: FavoritesStore(repository: repository))
    }
    
    let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            Group {
                if store.favorites.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "heart")
                            .font(.system(size: 48))
                            .foregroundStyle(.gray)
                        Text("No Favorites Yet")
                            .font(.headline)
                        Text("Add your favorite Pokémon from the list")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(store.favorites, id: \.id) { poke in
                                NavigationLink(value: poke.name) {
                                    PokemonGridCard(pokemon: poke)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Favorites")
            .navigationDestination(for: String.self) { name in
                PokemonDetailView(pokemonName: name, repo: repository)
            }
        }
    }
}
