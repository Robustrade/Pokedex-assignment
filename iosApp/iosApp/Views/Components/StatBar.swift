import SwiftUI
import shared

struct StatBar: View {
    let stat: PokemonStat
    
    private var normalizedValue: Double {
        min(Double(stat.value) / 255.0, 1.0)
    }
    
    private var displayName: String {
        switch stat.name.lowercased() {
        case "hp": return "HP"
        case "attack": return "Attack"
        case "defense": return "Defense"
        case "special-attack": return "Sp. Atk"
        case "special-defense": return "Sp. Def"
        case "speed": return "Speed"
        default: return stat.name.capitalized
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Text(displayName)
                .font(.subheadline)
                .frame(width: 70, alignment: .leading)
                .foregroundStyle(.secondary)
            
            Text("\(stat.value)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(width: 40, alignment: .trailing)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray5))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(PokemonColors.statColor(for: stat.name))
                        .frame(width: geometry.size.width * normalizedValue, height: 8)
                        .animation(.easeOut(duration: 0.6), value: normalizedValue)
                }
            }
            .frame(height: 8)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        StatBar(stat: PokemonStat(name: "hp", value: 45))
        StatBar(stat: PokemonStat(name: "attack", value: 49))
        StatBar(stat: PokemonStat(name: "defense", value: 49))
        StatBar(stat: PokemonStat(name: "special-attack", value: 65))
        StatBar(stat: PokemonStat(name: "special-defense", value: 65))
        StatBar(stat: PokemonStat(name: "speed", value: 45))
    }
    .padding()
}
