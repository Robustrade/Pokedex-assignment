//
//  StatBarView.swift
//  iosApp
//
//  Created by Akash K on 13/04/26.
//

import SwiftUI
import Charts
import shared

struct StatsView: View {

    let pokemonDetail: PokemonDetail

    @State private var animatedWidth: CGFloat = 0

    var body: some View {
        Chart {
            ForEach(pokemonDetail.stats, id: \.name) { stat in
                BarMark(
                    x: .value("Name", statLabel(stat.name)),
                    y: .value("Value", stat.value)
                )
                .foregroundStyle(barColor(value: stat.value).gradient)
                .cornerRadius(5)
            }
        }
        .frame(height: 300)
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    func statLabel(_ statName: String) -> String {
        switch statName.lowercased() {
        case "hp": return "HP"
        case "attack": return "ATK"
        case "defense": return "DEF"
        case "special-attack": return "SATK"
        case "special-defense": return "SDEF"
        case "speed": return "SPD"
        default: return statName.uppercased()
        }
    }
    
    func barColor(value: Int32) -> Color {
        let ratio = Double(value) / Double(100)
        switch ratio {
        case ..<0.25: return .red
        case ..<0.50: return .orange
        case ..<0.75: return .yellow
        default: return .green
        }

    }
}
