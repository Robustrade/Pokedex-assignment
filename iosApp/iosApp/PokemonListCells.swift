import SwiftUI
import shared

struct PokemonGridCell: View {
    let pokemon: Pokemon

    var body: some View {
        VStack(spacing: 8) {
            AsyncImage(url: URL(string: pokemon.imageUrl ?? "")) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 80, height: 80)

            Text(pokemon.name.capitalized)
                .font(.subheadline)
                .fontWeight(.medium)

            Text("#\(String(format: "%03d", pokemon.id))")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct PokemonListCell: View {
    let pokemon: Pokemon

    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: pokemon.imageUrl ?? "")) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 60, height: 60)

            VStack(alignment: .leading, spacing: 4) {
                Text(pokemon.name.capitalized)
                    .font(.headline)
                Text("#\(String(format: "%03d", pokemon.id))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
