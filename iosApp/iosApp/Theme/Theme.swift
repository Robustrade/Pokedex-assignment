import SwiftUI

/// Central design tokens for the PokéDex app.
enum Theme {

    // MARK: - Colours

    static let accentColor = Color(red: 0.91, green: 0.26, blue: 0.26)    // Pokéball red
    static let cardBackground = Color("CardBackground", bundle: nil)

    static var primaryBackground: Color {
        Color(uiColor: .systemBackground)
    }

    static var secondaryBackground: Color {
        Color(uiColor: .secondarySystemBackground)
    }

    // MARK: - Gradients

    static func typeGradient(_ type: String) -> LinearGradient {
        let base = TypeColors.color(for: type)
        return LinearGradient(
            colors: [base.opacity(0.8), base.opacity(0.4)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    // MARK: - Spacing

    static let cornerRadius: CGFloat = 16
    static let cardCornerRadius: CGFloat = 14
    static let smallCornerRadius: CGFloat = 8
    static let padding: CGFloat = 16
    static let smallPadding: CGFloat = 8

    // MARK: - Typography helpers

    static func pokemonId(_ id: Int) -> String {
        String(format: "#%03d", id)
    }

    static func pokemonName(_ name: String) -> String {
        name.prefix(1).uppercased() + name.dropFirst()
    }

    static func formattedHeight(_ decimetres: Int) -> String {
        let metres = Double(decimetres) / 10.0
        return String(format: "%.1f m", metres)
    }

    static func formattedWeight(_ hectograms: Int) -> String {
        let kg = Double(hectograms) / 10.0
        return String(format: "%.1f kg", kg)
    }
}
