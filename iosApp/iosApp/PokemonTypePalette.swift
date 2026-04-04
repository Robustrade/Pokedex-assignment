import SwiftUI
import UIKit

/// Type chip colors that adapt to light / dark mode.
enum PokemonTypePalette {
    private static func dynamic(light: UIColor, dark: UIColor) -> Color {
        Color(
            UIColor { trait in
                trait.userInterfaceStyle == .dark ? dark : light
            }
        )
    }

    static func color(for type: String) -> Color {
        switch type.lowercased() {
        case "normal": return dynamic(light: rgb(0.66, 0.65, 0.48), dark: rgb(0.78, 0.76, 0.58))
        case "fire": return dynamic(light: rgb(0.93, 0.51, 0.19), dark: rgb(1.0, 0.62, 0.28))
        case "water": return dynamic(light: rgb(0.28, 0.57, 0.94), dark: rgb(0.45, 0.72, 1.0))
        case "electric": return dynamic(light: rgb(0.97, 0.82, 0.17), dark: rgb(1.0, 0.92, 0.35))
        case "grass": return dynamic(light: rgb(0.48, 0.78, 0.30), dark: rgb(0.55, 0.88, 0.42))
        case "ice": return dynamic(light: rgb(0.59, 0.85, 0.84), dark: rgb(0.72, 0.94, 0.93))
        case "fighting": return dynamic(light: rgb(0.76, 0.18, 0.16), dark: rgb(0.92, 0.38, 0.34))
        case "poison": return dynamic(light: rgb(0.64, 0.24, 0.63), dark: rgb(0.82, 0.45, 0.80))
        case "ground": return dynamic(light: rgb(0.89, 0.75, 0.40), dark: rgb(0.96, 0.84, 0.55))
        case "flying": return dynamic(light: rgb(0.66, 0.56, 0.95), dark: rgb(0.78, 0.70, 1.0))
        case "psychic": return dynamic(light: rgb(0.98, 0.33, 0.53), dark: rgb(1.0, 0.52, 0.68))
        case "bug": return dynamic(light: rgb(0.65, 0.73, 0.10), dark: rgb(0.76, 0.84, 0.28))
        case "rock": return dynamic(light: rgb(0.71, 0.63, 0.21), dark: rgb(0.86, 0.78, 0.42))
        case "ghost": return dynamic(light: rgb(0.51, 0.45, 0.68), dark: rgb(0.68, 0.62, 0.86))
        case "dragon": return dynamic(light: rgb(0.44, 0.21, 0.99), dark: rgb(0.58, 0.42, 1.0))
        case "dark": return dynamic(light: rgb(0.44, 0.34, 0.27), dark: rgb(0.62, 0.52, 0.45))
        case "steel": return dynamic(light: rgb(0.72, 0.72, 0.81), dark: rgb(0.85, 0.86, 0.93))
        case "fairy": return dynamic(light: rgb(0.94, 0.59, 0.68), dark: rgb(1.0, 0.74, 0.82))
        default: return Color(.secondarySystemFill)
        }
    }

    private static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
        UIColor(red: r, green: g, blue: b, alpha: 1)
    }
}
