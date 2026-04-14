//
//  RootView.swift
//  iosApp
//
//  Created by Akash K on 12/04/26.
//

import SwiftUI

struct RootView: View {
    @Environment(\.viewModelFactory) private var viewModelFactory

    var body: some View {
        TabView {
            ListView(viewModel: viewModelFactory.makeListViewModel)
                .tabItem {
                    Label("Pokédex", systemImage: "square.grid.2x2.fill")
                }
            FavouritesView(viewModel: viewModelFactory.makeFavouritesViewModel)
                .tabItem {
                    Label("Favourites", systemImage: "heart.fill")
                }
        }.tint(.red)
    }
}

#Preview {
    RootView()
        .environment(\.viewModelFactory, AppDependencies())
}
