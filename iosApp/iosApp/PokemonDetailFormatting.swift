import Foundation
import shared

/// Pure formatting / bridging helpers for Pokémon detail data (no SwiftUI).
enum PokemonDetailFormatting {

    static func stringArray(from value: Any) -> [String] {
        if let a = value as? [String] { return a }
        if let ns = value as? NSArray {
            return (0..<ns.count).compactMap { ns.object(at: $0) as? String }
        }
        return []
    }

    static func statArray(from value: Any) -> [PokemonStat] {
        if let a = value as? [PokemonStat] { return a }
        if let ns = value as? NSArray {
            return (0..<ns.count).compactMap { ns.object(at: $0) as? PokemonStat }
        }
        return []
    }

    static func statDisplayName(_ raw: String) -> String {
        switch raw.lowercased() {
        case "hp": return "HP"
        case "attack": return "Attack"
        case "defense": return "Defense"
        case "special-attack": return "Sp. Atk"
        case "special-defense": return "Sp. Def"
        case "speed": return "Speed"
        default: return raw.replacingOccurrences(of: "-", with: " ").capitalized
        }
    }

    static func heightMeters(fromDecimeters dm: Int32) -> Double {
        Double(dm) / 10.0
    }

    static func weightKg(fromHectograms hg: Int32) -> Double {
        Double(hg) / 10.0
    }

    static func maxStatValue(for stats: [PokemonStat]) -> Int {
        max(stats.map { Int($0.value) }.max() ?? 1, 1)
    }
}
