//
//  FavoritesView.swift
//  iosApp
//
//  Created by vishwas on 4/2/26.
//


import SwiftUI
import shared

import SwiftUI
import shared

struct FavoritesView: View {

    @StateObject private var store = FavoritesStore()

    var body: some View {
        ZStack {
            Color.screenBg.ignoresSafeArea()

            if store.favorites.isEmpty {
                FavoritesEmptyStateView()
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(store.favorites, id: \.id) { pokemon in
                            NavigationLink(value: pokemon.name) {
                                FavoriteRowView(pokemon: pokemon)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 16)
                }
            }
        }
        .navigationTitle("Favourites")
    }
}
