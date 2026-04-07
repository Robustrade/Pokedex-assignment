//
//  FavouriteEmpty.swift
//  iosApp
//
//  Created by vishwas on 4/3/26.
//

import SwiftUI

struct FavoritesEmptyStateView: View {
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "heart.slash")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            
            Text("No Favourites Yet")
                .font(.title3.weight(.semibold))
            
            Text("Tap the heart on a Pokémon's\ndetail page to add it here.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
