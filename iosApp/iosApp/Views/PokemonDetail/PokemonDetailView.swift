import SwiftUI
import shared

struct PokemonDetailView: View {
    let pokemonName: String
    @StateObject private var store: PokemonDetailStore
    @Environment(\.dismiss) private var dismiss
    
    init(pokemonName: String) {
        self.pokemonName = pokemonName
        _store = StateObject(wrappedValue: PokemonDetailStore(pokemonName: pokemonName))
    }
    
    var body: some View {
        ZStack {
            backgroundGradient
            contentView
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if let success = store.state.successState {
                    favoriteButton(isFavorite: success.pokemon.isFavorite)
                }
            }
        }
    }
    
    @ViewBuilder
    private var backgroundGradient: some View {
        if let success = store.state.successState,
           let firstType = success.pokemon.types.first {
            LinearGradient(
                colors: [
                    PokemonColors.typeColor(for: firstType).opacity(0.3),
                    Color(.systemBackground)
                ],
                startPoint: .top,
                endPoint: .center
            )
            .ignoresSafeArea()
        } else {
            Color(.systemBackground)
                .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        if store.state.isLoading {
            loadingView
        } else if let success = store.state.successState {
            detailContent(success.pokemon)
        } else if let error = store.state.errorState {
            errorView(error.message)
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading details...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    private func detailContent(_ pokemon: PokemonDetail) -> some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection(pokemon)
                physicalAttributesSection(pokemon)
                typesSection(pokemon)
                statsSection(pokemon)
                abilitiesSection(pokemon)
            }
            .padding()
        }
    }
    
    private func headerSection(_ pokemon: PokemonDetail) -> some View {
        VStack(spacing: 8) {
            AsyncImage(url: URL(string: pokemon.imageUrl)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 200, height: 200)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
                case .failure:
                    Image(systemName: "photo")
                        .font(.system(size: 80))
                        .foregroundStyle(.secondary)
                        .frame(width: 200, height: 200)
                @unknown default:
                    EmptyView()
                }
            }
            
            Text("#\(pokemon.id)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Text(pokemon.name.capitalized)
                .font(.largeTitle)
                .fontWeight(.bold)
        }
    }
    
    private func physicalAttributesSection(_ pokemon: PokemonDetail) -> some View {
        HStack(spacing: 40) {
            VStack(spacing: 4) {
                Image(systemName: "ruler")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                Text(String(format: "%.1f m", Double(pokemon.height) / 10.0))
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("Height")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Divider()
                .frame(height: 60)
            
            VStack(spacing: 4) {
                Image(systemName: "scalemass")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                Text(String(format: "%.1f kg", Double(pokemon.weight) / 10.0))
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("Weight")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
    }
    
    private func typesSection(_ pokemon: PokemonDetail) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Types")
                .font(.headline)
            
            HStack(spacing: 12) {
                ForEach(pokemon.types, id: \.self) { type in
                    TypeChip(type: type)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func statsSection(_ pokemon: PokemonDetail) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Base Stats")
                .font(.headline)
            
            ForEach(pokemon.stats, id: \.name) { stat in
                StatBar(stat: stat)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
    }
    
    private func abilitiesSection(_ pokemon: PokemonDetail) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Abilities")
                .font(.headline)
            
            FlowLayout(spacing: 8) {
                ForEach(pokemon.abilities, id: \.self) { ability in
                    Text(ability.capitalized.replacingOccurrences(of: "-", with: " "))
                        .font(.subheadline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color(.tertiarySystemBackground))
                        )
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func favoriteButton(isFavorite: Bool) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                store.toggleFavorite()
            }
        }) {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(.title2)
                .foregroundStyle(isFavorite ? .red : .secondary)
                .scaleEffect(isFavorite ? 1.1 : 1.0)
        }
    }
    
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundStyle(.red)
            
            Text("Failed to load details")
                .font(.headline)
            
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: {
                store.retry()
            }) {
                Label("Retry", systemImage: "arrow.clockwise")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.accentColor)
                    .clipShape(Capsule())
            }
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        PokemonDetailView(pokemonName: "bulbasaur")
    }
}
