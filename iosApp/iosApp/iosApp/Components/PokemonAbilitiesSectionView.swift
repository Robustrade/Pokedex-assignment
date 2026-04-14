//
//  PokemonAbilitiesSectionView.swift
//  iosApp
//
//  Created by Akash K on 13/04/26.
//

import SwiftUI

struct PokemonAbilitiesSectionView: View {
    let abilities: [String]
    
    private let abilityColumns = [
        GridItem(.adaptive(minimum: 100), spacing: 8, alignment: .leading)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitleView(title: "Abilities")

            LazyVGrid(columns: abilityColumns, alignment: .leading, spacing: 8) {
                ForEach(abilities, id: \.self) { ability in
                    Text(ability.replacingOccurrences(of: "-", with: " ").capitalized)
                        .font(.subheadline.weight(.medium))
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.ultraThinMaterial)
                        )
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(.quaternary, lineWidth: 1)
        )
    }
}
