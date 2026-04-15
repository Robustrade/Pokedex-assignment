import SwiftUI
import shared

struct FavoritesView: View {
    @StateObject private var store = FavoritesStore()
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                if store.favorites.isEmpty {
                    emptyStateView
                } else {
                    favoritesGrid
                }
            }
            .navigationTitle("Favorites")
            .animation(.easeInOut(duration: 0.3), value: store.favorites.count)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.slash")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            
            Text("No Favorites Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Tap the heart icon on any Pokémon\nto add it to your favorites")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    private var favoritesGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(store.favorites, id: \.id) { pokemon in
                    NavigationLink(value: pokemon) {
                        FavoriteGridCell(pokemon: pokemon)
                            .transition(.asymmetric(
                                insertion: .scale.combined(with: .opacity),
                                removal: .scale.combined(with: .opacity)
                            ))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .navigationDestination(for: Pokemon.self) { pokemon in
            PokemonDetailView(pokemonName: pokemon.name)
        }
    }
}

struct FavoriteGridCell: View {
    let pokemon: Pokemon
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: pokemon.imageUrl)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 100, height: 100)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                    case .failure:
                        Image(systemName: "photo")
                            .font(.system(size: 40))
                            .foregroundStyle(.secondary)
                            .frame(width: 100, height: 100)
                    @unknown default:
                        EmptyView()
                    }
                }
                
                Image(systemName: "heart.fill")
                    .font(.caption)
                    .foregroundStyle(.red)
                    .padding(4)
            }
            
            VStack(spacing: 2) {
                Text("#\(pokemon.id)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                
                Text(pokemon.name.capitalized)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

#Preview {
    FavoritesView()
}
