import SwiftUI

struct TypeChipView: View {
    
    let type: String
    
    var body: some View {
        Text(type.capitalized)
            .font(.caption.weight(.semibold))
            .foregroundStyle(PokemonTypeColor.color(for: type))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .stroke(PokemonTypeColor.color(for: type).opacity(0.8), lineWidth: 1.5)
                    .background(
                        Capsule()
                            .fill(PokemonTypeColor.color(for: type).opacity(0.12))
                    )
            )
    }
}
