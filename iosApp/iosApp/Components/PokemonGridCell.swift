import SwiftUI
import shared

struct PokemonGridCell: View {
    
    let pokemon: Pokemon
    
    var body: some View {
        VStack(spacing: 8) {
            AsyncImage(url: URL(string: pokemon.imageUrl)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure:
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                default:
                    ProgressView()
                }
            }
            .frame(width: 100, height: 100)
            
            Text(PokemonFormatter.displayName(pokemon.name))
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
                .lineLimit(1)
            
            Text(PokemonFormatter.formattedId(pokemon.id))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .background(Color.cardBg)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
    }
}
