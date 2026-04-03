//
//  PokemonInfo.swift
//  iosApp
//
//  Created by vishwas on 4/3/26.
//

import SwiftUI
import shared

struct PokemonInfoSection: View {
    let detail: PokemonDetail
    let store: PokemonDetailStore

    var body: some View {
        HStack(spacing: 0) {
            infoTile(title: "Height", value: store.formattedHeight(detail.height))
            Divider().frame(height: 40)
            infoTile(title: "Weight", value: store.formattedWeight(detail.weight))
        }
        .padding()
        .background(Color.cardBg)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .padding(.horizontal)
        .padding(.bottom, 16)
    }

    private func infoTile(title: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.title3.weight(.semibold))
        }
        .frame(maxWidth: .infinity)
    }
}
