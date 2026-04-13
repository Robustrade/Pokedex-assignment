//
//  FavoriteRowView.swift
//  iosApp
//
//  Created by Akash K on 13/04/26.
//

import SwiftUI
import shared

struct FavoriteRowView: View {
    let pokemon: Pokemon

    var body: some View {
        HStack(spacing: 14) {
            AsyncImage(url: URL(string: pokemon.imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 56, height: 56)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            VStack(alignment: .leading, spacing: 2) {
                Text(PokemonDisplayFormatter.formattedName(pokemon.name))
                    .font(.body.weight(.semibold))

                Text(PokemonDisplayFormatter.formattedID(pokemon.id))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "heart.fill")
                .foregroundStyle(.red)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(uiColor: .secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(.quaternary, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}
