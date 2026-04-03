//
//  FavouriteRow.swift
//  iosApp
//
//  Created by vishwas on 4/3/26.
//
import SwiftUI
import shared

struct FavoriteRowView: View {
    let pokemon: Pokemon

    var body: some View {
        HStack(spacing: 14) {
            PokemonImageView(url: pokemon.imageUrl)
                .frame(width: 56, height: 56)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            VStack(alignment: .leading, spacing: 2) {
                Text(PokemonFormatter.displayName(pokemon.name))
                    .font(.body.weight(.semibold))

                Text(PokemonFormatter.formattedId(pokemon.id))
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
                .fill(Color.cardBg)
        )
        .padding(.horizontal)
        .padding(.vertical, 4)
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
    }
}
