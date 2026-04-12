import SwiftUI
import shared

/// A single grid cell displaying a Pokémon's artwork, name and ID.
struct PokemonCardView: View {

    let pokemon: Pokemon

    @State private var imageId = UUID()

    var body: some View {
        // Enforce pure static string construction to bypass string corruptions.
        let safeId = pokemon.id > 0 ? pokemon.id : Int32(URL(string: pokemon.imageUrl)?.lastPathComponent.replacingOccurrences(of: ".png", with: "") ?? "0") ?? 1
        let finalUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(safeId).png"

        VStack(spacing: 4) {
            // Artwork
            AsyncImage(url: URL(string: finalUrl)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure:
                    Image(systemName: "photo.circle")
                        .font(.largeTitle)
                        .foregroundStyle(.tertiary)
                        .onAppear {
                            // SwiftUI AsyncImage failure bug when mounted in inactive TabView
                            // Refresh id to force a remount when visible
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                imageId = UUID()
                            }
                        }
                default:
                    ProgressView()
                }
            }
            .id(imageId)
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
