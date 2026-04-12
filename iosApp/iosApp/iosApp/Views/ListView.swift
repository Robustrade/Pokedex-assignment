//
//  ListView.swift
//  iosApp
//
//  Created by Akash K on 12/04/26.
//

import SwiftUI
import shared

struct ListView: View {
    
    @StateObject private var viewModel = ListViewModel()
    @State private var searchText = ""
    
    private let column = [
        GridItem(.flexible(minimum: 0, maximum: .infinity), spacing: 12),
        GridItem(.flexible(minimum: 0, maximum: .infinity), spacing: 12)
    ]
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.listState {
                case is PokemonListState.Loading:
                    ProgressView("Loading Pokémon…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case let error as PokemonListState.Error :
                    Text("Error \(error.debugDescription)")
                case let success as PokemonListState.Success:
                    let list = success.pokemon
                    if list.isEmpty {
                        EmptyStateView(iconName: "exclamationmark.magnifyingglass", title: "No Pokémon Found")
                    } else {
                        ScrollView {
                            LazyVGrid(columns: column, spacing: 12) {
                                ForEach(list, id: \.id) { pokemon in
                                    NavigationLink {
                                        Text(pokemon.name.capitalized)
                                    } label: {
                                        GridCell(pokemon: pokemon)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.vertical, 12)
                        }
                        .scrollIndicators(.hidden)
                        .padding(.horizontal, 12)
                        .refreshable {
                            viewModel.refresh()
                        }
                    }
                default:
                    EmptyView()
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Pokédex")
        }
        .onChange(of: searchText) { newValue in
            viewModel.search(newValue)
        }
    }
}

#Preview {
    ListView()
}
