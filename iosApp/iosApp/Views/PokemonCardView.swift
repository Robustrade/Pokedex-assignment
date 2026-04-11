import SwiftUI
import shared

/// A single grid cell displaying a Pokémon's artwork, name and ID.
struct PokemonCardView: View {

    let pokemon: Pokemon

    var body: some View {
        VStack(spacing: 4) {
            // Artwork
            AsyncImage(url: URL(string: pokemon.imageUrl)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure:
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                default:
                    ProgressView()
                }
            }
            .frame(width: 100, height: 100)
            .padding(.top, 8)

            // ID
            Text(Theme.pokemonId(Int(pokemon.id)))
                .font(.system(.caption2, design: .monospaced, weight: .medium))
                .foregroundStyle(.secondary)

            // Name
            Text(Theme.pokemonName(pokemon.name))
                .font(.system(.subheadline, weight: .semibold))
                .lineLimit(1)
                .padding(.bottom, 8)
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: Theme.cardCornerRadius, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.cardCornerRadius, style: .continuous)
                .strokeBorder(Color.primary.opacity(0.06), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
    }
}
