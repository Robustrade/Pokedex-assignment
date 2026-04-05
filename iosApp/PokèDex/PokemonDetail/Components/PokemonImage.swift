//
//  PokemonImage.swift
//  PokèDex
//
//  Created by Dharamrajsinh Jadeja on 05/04/26.
//
import SwiftUI
import Kingfisher

struct PokemonImage: View {
    let imageUrl: String

    var body: some View {
        KFImage(URL(string: imageUrl))
            .resizable()
            .placeholder {
                Color.gray.opacity(0.1)
                    .overlay { ProgressView() }
            }
            .fade(duration: 0.2)
            .cacheOriginalImage()
            .scaledToFit()
            .frame(height: 240)
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding()
    }
}
