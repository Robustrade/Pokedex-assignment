//
//  PokemonDetailView.swift
//  PokèDex
//
//  Created by Dharamrajsinh Jadeja on 05/04/26.
//

import SwiftUI

/// Detail view for a single Pokemon
struct PokemonDetailView: View {
    let pokemonName: String
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Details for \(pokemonName.capitalized)")
                .font(.headline)
            Text("(To be implemented)")
                .font(.caption)
                .foregroundStyle(.secondary)
            Spacer()
        }
        .padding()
        .navigationTitle(pokemonName.capitalized)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PokemonDetailView(pokemonName: "Pikachu")
    }
}
