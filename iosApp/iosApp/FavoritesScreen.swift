import SwiftUI
import shared

// MARK: - Screen (uses shared `FavoritesViewModel`)

struct FavoritesScreen: View {
    @StateObject private var model: FavoritesScreenModel
    private let repository: PokemonRepository

    init(repository: PokemonRepository) {
        self.repository = repository
        _model = StateObject(wrappedValue: FavoritesScreenModel(repository: repository))
    }

    var body: some View {
        Group {
            if model.favorites.isEmpty {
                emptyView
            } else {
                List(model.favorites, id: \.id) { pokemon in
                    NavigationLink(value: pokemon.name) {
                        FavoriteRow(pokemon: pokemon)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Favorites")
        .navigationDestination(for: String.self) { name in
            PokemonDetailScreen(pokemonName: name, repository: repository)
        }
    }

    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.slash")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("No favorites yet")
                .font(.headline)
            Text("Open a Pokémon and tap the heart to save it here.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct FavoriteRow: View {
    let pokemon: Pokemon

    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: pokemon.imageUrl)) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 56, height: 56)

            VStack(alignment: .leading, spacing: 4) {
                Text(pokemon.name.capitalized)
                    .font(.headline)
                Text("#\(String(format: "%03d", pokemon.id))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}
