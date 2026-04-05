//
//  PokemonGridCard.swift
//  PokèDex
//
//  Created by Dharamrajsinh Jadeja on 05/04/26.
//

import SwiftUI
import shared

/// Individual Pokemon card component for grid display
struct PokemonGridCard: View {
    let pokemon: Pokemon
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Image
            AsyncImage(url: URL(string: pokemon.imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .overlay {
                        ProgressView()
                    }
            }
            .frame(height: 120)
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            
            // Name
            Text(pokemon.name.capitalized)
                .font(.headline)
                .lineLimit(1)
            
            // ID
            Text("#\(String(format: "%04d", pokemon.id))")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
