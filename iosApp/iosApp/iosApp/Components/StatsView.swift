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

    private let pastelPalette: [Color] = [
        Color(red: 0.95, green: 0.66, blue: 0.66),
        Color(red: 0.98, green: 0.78, blue: 0.56),
        Color(red: 0.98, green: 0.89, blue: 0.60),
        Color(red: 0.72, green: 0.87, blue: 0.68),
        Color(red: 0.67, green: 0.83, blue: 0.95),
        Color(red: 0.82, green: 0.74, blue: 0.95)
    ]

    var body: some View {
        Chart {
            ForEach(Array(pokemonDetail.stats.enumerated()), id: \.element.name) { index, stat in
                let color = pastelPalette[index % pastelPalette.count]

                BarMark(
                    x: .value("Value", Int(stat.value)),
                    y: .value("Stat", statLabel(stat.name))
                )
                .foregroundStyle(color.gradient)
                .cornerRadius(8)

                PointMark(
                    x: .value("Value", Int(stat.value)),
                    y: .value("Stat", statLabel(stat.name))
                )
                .annotation(position: .trailing, spacing: 6) {
                    Text("\(stat.value)")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
                .opacity(0.001)
            }
        }
        .chartXScale(domain: 0...max(120, maxStatValue + 10))
        .chartXAxis {
            AxisMarks(position: .bottom)
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartPlotStyle { plotArea in
            plotArea
                .background(.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .frame(height: 280)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(.quaternary, lineWidth: 1)
        )
    }
    
    private var maxStatValue: Int {
        pokemonDetail.stats.map { Int($0.value) }.max() ?? 100
    }

    func statLabel(_ statName: String) -> String {
        switch statName.lowercased() {
        case "hp":
            return statName.uppercased()
        case "attack", "defense", "speed":
            return statName.capitalized
        case "special-attack", "special-defense":
            return statName.replacingOccurrences(of: "-", with: " ").capitalized
        default:
            return statName.uppercased()
        }
    }
    
}
