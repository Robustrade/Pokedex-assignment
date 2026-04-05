//
//  PokemonListView.swift
//  PokèDex
//
//  Created by Dharamrajsinh Jadeja on 05/04/26.
//

import SwiftUI
import shared

struct PokemonListView: View {
    let repository: PokemonRepository
    
    @StateObject private var store: PokemonListStore
    @State private var searchText = ""
    
    private let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 16)
    ]
    
    init(repository: PokemonRepository) {
        self.repository = repository
        _store = StateObject(wrappedValue: PokemonListStore(repository: repository))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                SearchBar(text: $searchText)
                    .onChange(of: searchText) { newValue in
                        store.search(newValue)
                    }
                
                PokemonGridView(
                    state: store.state,
                    columns: columns,
                    store: store
                )
                
                Spacer()
            }
            .navigationTitle("PokéDex")
            .navigationDestination(for: String.self) { name in
                PokemonDetailView(pokemonName: name)
            }
        }
    }
}
