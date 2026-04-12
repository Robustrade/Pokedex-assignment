import SwiftUI
import shared

/// Main Pokémon list screen with grid layout, search bar, and infinite scroll.
struct PokemonListView: View {

    @StateObject private var store: PokemonListStore
    @State private var searchText = ""

    private let repository: PokemonRepository

    init(repository: PokemonRepository) {
        self.repository = repository
        _store = StateObject(wrappedValue: PokemonListStore(repository: repository))
    }

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        NavigationStack {
            Group {
                if store.state is PokemonListState.Loading {
                    loadingView
                } else if let errorState = store.state as? PokemonListState.Error {
                    errorView(message: errorState.message)
                } else if let successState = store.state as? PokemonListState.Success {
                    pokemonGrid(successState)
                }
            }
            .navigationTitle("Pokédex")
            .searchable(text: $searchText, prompt: "Search Pokémon")
            .onChange(of: searchText) { newValue in
                store.search(newValue)
            }
            .refreshable {
                store.refresh()
            }
        }
    }

    // MARK: - Sub-views

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            Text("Loading Pokémon…")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button("Retry") {
                store.refresh()
            }
            .buttonStyle(.borderedProminent)
            .tint(Theme.accentColor)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private func pokemonGrid(_ state: PokemonListState.Success) -> some View {
        let pokemonList = state.pokemon as? [Pokemon] ?? []
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(pokemonList, id: \.id) { pokemon in
                    NavigationLink(value: pokemon) {
                        PokemonCardView(pokemon: pokemon)
                    }
                    .buttonStyle(.plain)
                    .onAppear {
                        if pokemon.id == pokemonList.last?.id {
                            store.loadNextPage()
                        }
                    }
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                }

                if state.isLoadingMore {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                }
            }
            .padding(.horizontal)
            .animation(.easeInOut(duration: 0.25), value: pokemonList.count)
        }
        .navigationDestination(for: Pokemon.self) { pokemon in
            PokemonDetailView(
                pokemonName: pokemon.name,
                repository: repository
            )
        }
    }
}
