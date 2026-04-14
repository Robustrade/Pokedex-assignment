//
//  GridCell.swift
//  iosApp
//
//  Created by Akash K on 12/04/26.
//

import SwiftUI
import shared
import UIKit
import Combine

struct GridCell: View {
    let pokemon: Pokemon

    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var imageLoader: PokemonImageLoader

    private var cardFill: Color {
        Color(uiColor: .secondarySystemBackground)
    }

    private var cardStroke: Color {
        colorScheme == .dark ? .white.opacity(0.18) : .black.opacity(0.08)
    }

    private var cardShadow: Color {
        colorScheme == .dark ? .clear : .black.opacity(0.08)
    }

    init(pokemon: Pokemon) {
        self.pokemon = pokemon
        _imageLoader = StateObject(wrappedValue: PokemonImageLoader(urlString: pokemon.imageUrl))
    }

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 10) {
                imageContent
                    .frame(width: 96, height: 96)

                Text(pokemon.name.capitalized)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity, minHeight: 150, alignment: .top)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(cardFill)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(cardStroke, lineWidth: 1)
            )
            .shadow(color: cardShadow, radius: 6, x: 0, y: 2)

            Text(PokemonDisplayFormatter.formattedID(pokemon.id))
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
                .background(
                    Capsule()
                        .stroke(.secondary.opacity(0.4), lineWidth: 1)
                )
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }

        .task {
            imageLoader.loadIfNeeded()
        }
    }

    @ViewBuilder
    private var imageContent: some View {
        if let uiImage = imageLoader.image {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
        } else if imageLoader.isLoading {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            Image(systemName: imageLoader.hasFailed ? "exclamationmark.triangle" : "photo")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
