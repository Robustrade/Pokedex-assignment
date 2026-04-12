//
//  FavoritesEmptyStateView.swift
//  iosApp
//
//  Created by Akash K on 12/04/26.
//


import SwiftUI

struct EmptyStateView: View {
    var iconName: String
    var title: String
    var subtitle: String?
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: iconName)
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            
            Text(title)
                .font(.title3.weight(.semibold))
            
            if let subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
