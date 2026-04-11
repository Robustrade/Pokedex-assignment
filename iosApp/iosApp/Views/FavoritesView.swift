import SwiftUI
import shared

/// Favourites screen displaying saved Pokémon that reactively updates
/// whenever the underlying database changes.
struct FavoritesView: View {

    @StateObject private var store: FavoritesStore
    private let repository: PokemonRepository
    
    init(repository: PokemonRepository) {
        self.repository = repository
        _store = StateObject(wrappedValue: FavoritesStore(repository: repository))
    }

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        NavigationStack {
            Group {
                if store.favorites.isEmpty {
                    emptyState
                } else {
                    favouritesGrid
                }
            }
            .navigationTitle("Favourites")
            .animation(.easeInOut(duration: 0.25), value: store.favorites.count)
        }
    }

    // MARK: - Empty state

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.slash")
                .font(.system(size: 56))
                .foregroundStyle(.secondary.opacity(0.5))
            Text("No Favourites Yet")
                .font(.title3.bold())
                .foregroundStyle(.secondary)
            Text("Tap the heart icon on a Pokémon\nto add it to your favourites.")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Grid

    private var favouritesGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(store.favorites, id: \.id) { pokemon in
                    NavigationLink(value: pokemon) {
                        PokemonCardView(pokemon: pokemon)
                    }
                    .buttonStyle(.plain)
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .opacity
                    ))
                }
            }
            .padding(.horizontal)
        }
        .navigationDestination(for: Pokemon.self) { pokemon in
            PokemonDetailView(
                pokemonName: pokemon.name,
                repository: repository
            )
        }
    }
}
