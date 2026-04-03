//
//  PokemonAbilities.swift
//  iosApp
//
//  Created by vishwas on 4/3/26.
//
import SwiftUI
import shared
struct PokemonAbilitiesSection: View {
    let detail: PokemonDetail
    let store: PokemonDetailStore
    
    private let columns = [
        GridItem(.adaptive(minimum: 100), spacing: 8)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Abilities")
                .font(.headline)
                .padding(.horizontal)
            
            LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
                ForEach(detail.abilities, id: \.self) { ability in
                    Text(store.formattedAbility(ability))
                        .font(.subheadline)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray5))
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 32)
    }
}
