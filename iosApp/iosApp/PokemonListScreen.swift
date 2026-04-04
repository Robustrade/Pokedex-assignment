import SwiftUI
import shared

// MARK: - Screen (uses shared `PokemonListViewModel` via `PokemonListScreenModel`)

struct PokemonListScreen: View {
    @StateObject private var model: PokemonListScreenModel

    private let repository: PokemonRepository

    init(repository: PokemonRepository) {
        self.repository = repository
        _model = StateObject(wrappedValue: PokemonListScreenModel(repository: repository))
    }

    var body: some View {
        NavigationStack {
            Group {
                switch model.state {
                case is PokemonListState.Loading:
                    loadingView

                case let success as PokemonListState.Success:
                    if shouldShowEmptySearch(success) {
                        emptyView
                    } else {
                        contentView(success: success)
                    }

                case let error as PokemonListState.Error:
                    errorView(message: error.message)

                default:
                    EmptyView()
                }
            }
            .navigationTitle("Pokédex")
            .searchable(
                text: Binding(
                    get: { model.searchText },
                    set: { model.searchText = $0 }
                ),
                prompt: "Search Pokémon"
            )
            .onChange(of: model.searchText) { _, query in
                withAnimation(AppMotion.list) {
                    model.search(query)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation { model.toggleGridLayout() }
                    } label: {
                        Image(systemName: model.isGrid ? "list.bullet" : "square.grid.2x2")
                    }
                }
            }
            .navigationDestination(for: String.self) { name in
                PokemonDetailScreen(pokemonName: name, repository: repository)
            }
        }
    }

    private func shouldShowEmptySearch(_ success: PokemonListState.Success) -> Bool {
        let trimmed = model.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        return success.pokemon.isEmpty && !trimmed.isEmpty
    }

    @ViewBuilder
    private func contentView(success: PokemonListState.Success) -> some View {
        ScrollView {
            Group {
                if model.isGrid {
                    gridView(success: success)
                } else {
                    listView(success: success)
                }
            }
            .animation(AppMotion.list, value: model.isGrid)

            if success.isLoadingMore {
                ProgressView()
                    .padding()
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private func gridView(success: PokemonListState.Success) -> some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            ForEach(Array(success.pokemon.enumerated()), id: \.element.id) { index, pokemon in
                NavigationLink(value: pokemon.name) {
                    PokemonGridCell(pokemon: pokemon)
                }
                .buttonStyle(.plain)
                .onAppear {
                    model.loadMoreIfAtEnd(success: success, index: index)
                }
            }
        }
        .padding(.horizontal)
    }

    private func listView(success: PokemonListState.Success) -> some View {
        LazyVStack(spacing: 8) {
            ForEach(Array(success.pokemon.enumerated()), id: \.element.id) { index, pokemon in
                NavigationLink(value: pokemon.name) {
                    PokemonListCell(pokemon: pokemon)
                }
                .buttonStyle(.plain)
                .onAppear {
                    model.loadMoreIfAtEnd(success: success, index: index)
                }
            }
        }
        .padding(.horizontal)
    }

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("Loading Pokémon...")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("No Pokémon found")
                .font(.headline)
            Text("Try a different search term")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundStyle(.red)
            Text("Something went wrong")
                .font(.headline)
            Text(message)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button("Retry") {
                withAnimation(AppMotion.list) {
                    model.refresh()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
