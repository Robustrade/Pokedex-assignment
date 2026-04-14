//
//  FavouritesView.swift
//  iosApp
//
//  Created by Akash K on 12/04/26.
//

import SwiftUI
import shared

struct FavouritesView: View {
    @StateObject private var viewModel: FavouritesViewModel

    init(viewModel: @escaping () -> FavouritesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.favorites.isEmpty {
                    EmptyStateView(
                        iconName: "heart.slash",
                        title: "No Favourites Yet"
                    )
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        List(viewModel.favorites, id: \.id) { pokemon in
                            FavoriteRowView(pokemon: pokemon)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        viewModel.unfavourite(pokemon)
                                    } label: {
                                        Label("Unfavourite", systemImage: "heart.slash")
                                    }
                                }
                                .listRowInsets(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .navigationTitle("Favourites")
        }
    }
}

#Preview {
    FavouritesView(viewModel: { AppDependencies().makeFavouritesViewModel() })
}
