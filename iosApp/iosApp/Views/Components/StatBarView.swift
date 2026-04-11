import SwiftUI

/// Animated horizontal bar representing a single Pokémon base stat.
struct StatBarView: View {

    let statName: String
    let value: Int
    let maxValue: Int

    @State private var animatedWidth: CGFloat = 0

    private var label: String {
        switch statName.lowercased() {
        case "hp":              return "HP"
        case "attack":          return "ATK"
        case "defense":         return "DEF"
        case "special-attack":  return "SpA"
        case "special-defense": return "SpD"
        case "speed":           return "SPD"
        default:                return statName.uppercased()
        }
    }

    private var barColor: Color {
        let ratio = Double(value) / Double(maxValue)
        switch ratio {
        case ..<0.25: return .red
        case ..<0.50: return .orange
        case ..<0.75: return .yellow
        default:      return .green
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            Text(label)
                .font(.system(.caption, design: .monospaced, weight: .semibold))
                .foregroundStyle(.secondary)
                .frame(width: 36, alignment: .trailing)

            Text("\(value)")
                .font(.system(.caption, design: .monospaced, weight: .bold))
                .frame(width: 32, alignment: .trailing)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.primary.opacity(0.08))
                        .frame(height: 7)

                    Capsule()
                        .fill(barColor.gradient)
                        .frame(
                            width: animatedWidth,
                            height: 7
                        )
                }
                .onAppear {
                    withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                        let fraction = CGFloat(value) / CGFloat(maxValue)
                        animatedWidth = geo.size.width * min(fraction, 1.0)
                    }
                }
            }
            .frame(height: 7)
        }
    }
}
