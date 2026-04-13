//
//  DimensionView.swift
//  iosApp
//
//  Created by Akash K on 13/04/26.
//

import SwiftUI
import Foundation
import shared

struct DimensionView: View {
    
    let pokemonDetail: PokemonDetail
    
    var body: some View {
        VStack(spacing: 8) {
            detailCard(
                iconName: "ruler",
                title: "Height",
                value: formattedHeight
            )

            detailCard(
                iconName: "scalemass",
                title: "Weight",
                value: formattedWeight
            )
        }
        .frame(maxWidth: 80)
    }
    
    private var formattedHeight: String {
        let meters = Double(pokemonDetail.height) / 10.0
        return String(format: "%.1f m", meters)
    }

    private var formattedWeight: String {
        let kilograms = Double(pokemonDetail.weight) / 10.0
        return String(format: "%.1f kg", kilograms)
    }
    
    
    private func detailCard(iconName: String, title: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(.footnote, weight: .semibold))
            Image(systemName: iconName)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .accessibilityLabel(title)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .padding(.horizontal, 6)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.ultraThinMaterial)
        )
    }
}
