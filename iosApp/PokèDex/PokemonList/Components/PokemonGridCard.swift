//
//  PokemonGridCard.swift
//  PokèDex
//
//  Created by Dharamrajsinh Jadeja on 05/04/26.
//

import SwiftUI
import shared
import Kingfisher

struct PokemonGridCard: View {
    let pokemon: Pokemon

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            KFImage(URL(string: pokemon.imageUrl))
                .resizable()
                .placeholder {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .overlay { ProgressView() }
                }
                .fade(duration: 0.2)
                .cacheOriginalImage()
                .scaledToFit()
                .frame(height: 120)
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)

            Text(pokemon.name.capitalized)
                .font(.headline)
                .lineLimit(1)

            Text("#\(String(format: "%04d", pokemon.id))")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
