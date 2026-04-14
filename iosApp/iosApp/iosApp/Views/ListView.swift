//
//  ListView.swift
//  iosApp
//
//  Created by Akash K on 12/04/26.
//

import SwiftUI
import shared

struct ListView: View {
    @Environment(\.viewModelFactory) private var viewModelFactory
    @StateObject private var viewModel: ListViewModel
    @State private var searchText = ""

    init(viewModel: @escaping () -> ListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }

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
                case let error as PokemonListState.Error:
                    VStack(spacing: 16) {
                        Image(systemName: "wifi.exclamationmark")
                            .font(.system(size: 48))
                            .foregroundStyle(.secondary)
                        Text("Something went wrong")
                            .font(.title3.weight(.semibold))
                        Text(error.message)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        Button {
                            viewModel.refresh()
                        } label: {
                            Label("Retry", systemImage: "arrow.clockwise")
                                .font(.subheadline.weight(.medium))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(.tint.opacity(0.12), in: Capsule())
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                case let success as PokemonListState.Success:
                    let list = success.pokemon
                    if list.isEmpty {
                        EmptyStateView(
                            iconName: "exclamationmark.magnifyingglass",
                            title: "No Pokémon Found"
                        )
                    } else {
                        ScrollView {
                            LazyVGrid(columns: column, spacing: 12) {
                                ForEach(list, id: \.id) { pokemon in
                                    NavigationLink {
                                        DetailsView(
                                            name: pokemon.name,
                                            viewModel: viewModelFactory.makeDetailsViewModel
                                        )
                                    } label: {
                                        GridCell(pokemon: pokemon)
                                    }
                                    .buttonStyle(.plain)
                                    .onAppear {
                                        if pokemon.id == list.last?.id {
                                            viewModel.loadNextPage()
                                        }
                                    }
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
