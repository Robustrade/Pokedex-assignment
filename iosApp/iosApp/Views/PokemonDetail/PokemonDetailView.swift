import SwiftUI
import shared

/// Full detail screen for a single Pokémon.
/// All formatting is delegated to `PokemonDetailStore` — this view only renders.
struct PokemonDetailView: View {
    
    @StateObject private var store: PokemonDetailStore
    
    init(pokemonName: String) {
        _store = StateObject(wrappedValue: PokemonDetailStore(pokemonName: pokemonName))
    }
    
    var body: some View {
        ZStack {
            Color.screenBg.ignoresSafeArea()
            Group {
                switch store.state {
                case is PokemonDetailState.Loading:
                    ProgressView("Loading…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                case let success as PokemonDetailState.Success:
                    content(success.pokemon)
                    
                case let error as PokemonDetailState.Error:
                    PokemonErrorView(
                        message: error.message,
                        onRetry: store.retry
                    )
                    
                default:
                    EmptyView()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
    
    private func content(_ detail: PokemonDetail) -> some View {
        ScrollView {
            VStack(spacing: 0) {
                PokemonHeaderView(detail: detail, store: store)
                PokemonInfoSection(detail: detail, store: store)
                PokemonStatsSection(detail: detail, store: store)
                PokemonAbilitiesSection(detail: detail, store: store)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    store.toggleFavorite()
                } label: {
                    Image(systemName: detail.isFavorite ? "heart.fill" : "heart")
                        .foregroundStyle(detail.isFavorite ? .red : .secondary)
                        .font(.title3)
                }
            }
        }
        .navigationTitle(detail.name.capitalized)
    }
}
