import SwiftUI

enum PokemonColors {
    static let primary = Color("AppPrimaryColor", bundle: nil)
    static let secondary = Color("AccentColor", bundle: nil)
    
    static func typeColor(for type: String) -> Color {
        switch type.lowercased() {
        case "normal": return Color(hex: "A8A77A")
        case "fire": return Color(hex: "EE8130")
        case "water": return Color(hex: "6390F0")
        case "electric": return Color(hex: "F7D02C")
        case "grass": return Color(hex: "7AC74C")
        case "ice": return Color(hex: "96D9D6")
        case "fighting": return Color(hex: "C22E28")
        case "poison": return Color(hex: "A33EA1")
        case "ground": return Color(hex: "E2BF65")
        case "flying": return Color(hex: "A98FF3")
        case "psychic": return Color(hex: "F95587")
        case "bug": return Color(hex: "A6B91A")
        case "rock": return Color(hex: "B6A136")
        case "ghost": return Color(hex: "735797")
        case "dragon": return Color(hex: "6F35FC")
        case "dark": return Color(hex: "705746")
        case "steel": return Color(hex: "B7B7CE")
        case "fairy": return Color(hex: "D685AD")
        default: return Color.gray
        }
    }
    
    static func statColor(for stat: String) -> Color {
        switch stat.lowercased() {
        case "hp": return Color(hex: "FF5959")
        case "attack": return Color(hex: "F5AC78")
        case "defense": return Color(hex: "FAE078")
        case "special-attack", "sp. atk": return Color(hex: "9DB7F5")
        case "special-defense", "sp. def": return Color(hex: "A7DB8D")
        case "speed": return Color(hex: "FA92B2")
        default: return Color.gray
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
