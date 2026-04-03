import SwiftUI

// MARK: - App Theme Colors

extension Color {
    static let pokeBallRed   = Color(red: 0.86, green: 0.21, blue: 0.27)
    static let pokeBallDark  = Color(red: 0.17, green: 0.17, blue: 0.17)
    static let cardBg        = Color(.systemBackground)
    static let screenBg      = Color(.systemGroupedBackground)
}

// MARK: - Pokémon Type → Color mapping

enum PokemonTypeColor {

    static func color(for type: String) -> Color {
        switch type.lowercased() {
        case "normal":   return Color(red: 0.66, green: 0.65, blue: 0.48)
        case "fire":     return Color(red: 0.93, green: 0.51, blue: 0.19)
        case "water":    return Color(red: 0.39, green: 0.56, blue: 0.94)
        case "electric": return Color(red: 0.97, green: 0.82, blue: 0.17)
        case "grass":    return Color(red: 0.47, green: 0.78, blue: 0.30)
        case "ice":      return Color(red: 0.59, green: 0.85, blue: 0.84)
        case "fighting": return Color(red: 0.76, green: 0.18, blue: 0.16)
        case "poison":   return Color(red: 0.63, green: 0.24, blue: 0.63)
        case "ground":   return Color(red: 0.89, green: 0.75, blue: 0.40)
        case "flying":   return Color(red: 0.66, green: 0.56, blue: 0.95)
        case "psychic":  return Color(red: 0.98, green: 0.33, blue: 0.53)
        case "bug":      return Color(red: 0.65, green: 0.73, blue: 0.10)
        case "rock":     return Color(red: 0.71, green: 0.63, blue: 0.21)
        case "ghost":    return Color(red: 0.45, green: 0.34, blue: 0.60)
        case "dragon":   return Color(red: 0.44, green: 0.21, blue: 0.99)
        case "dark":     return Color(red: 0.44, green: 0.34, blue: 0.27)
        case "steel":    return Color(red: 0.72, green: 0.72, blue: 0.82)
        case "fairy":    return Color(red: 0.84, green: 0.52, blue: 0.68)
        default:         return .gray
        }
    }
}

// MARK: - Stat bar colour

enum StatColor {

    static func color(for value: Int32) -> Color {
        switch value {
        case ..<50:  return .red
        case ..<80:  return .orange
        case ..<100: return .yellow
        default:     return .green
        }
    }
}
