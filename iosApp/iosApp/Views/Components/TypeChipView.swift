import SwiftUI

/// Capsule-shaped chip displaying a Pokémon type with its canonical colour.
struct TypeChipView: View {

    let type: String

    var body: some View {
        Text(type.capitalized)
            .font(.system(.caption, weight: .bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(
                Capsule().fill(TypeColors.color(for: type).gradient)
            )
    }
}
