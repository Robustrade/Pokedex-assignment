import SwiftUI

struct TypeChip: View {
    let type: String
    
    var body: some View {
        Text(type.capitalized)
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(PokemonColors.typeColor(for: type))
            )
            .shadow(color: PokemonColors.typeColor(for: type).opacity(0.4), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    HStack {
        TypeChip(type: "grass")
        TypeChip(type: "poison")
        TypeChip(type: "fire")
        TypeChip(type: "water")
    }
    .padding()
}
