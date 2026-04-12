//
//  RootView.swift
//  iosApp
//
//  Created by Akash K on 12/04/26.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            ListView()
                .tabItem {
                    Label("Pokédex", systemImage: "square.grid.2x2.fill")
                }
            FavouritesView()
                .tabItem {
                    Label("Favourites", systemImage: "heart.fill")
                }
        }.tint(.red)
    }
}

