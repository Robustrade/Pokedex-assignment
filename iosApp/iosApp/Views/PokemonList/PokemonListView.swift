import SwiftUI
import shared

struct PokemonListView: View {
    @StateObject private var store = PokemonListStore()
    @State private var searchText = ""
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                contentView
            }
            .navigationTitle("Pokédex")
            .searchable(text: $searchText, prompt: "Search Pokémon")
            .onChange(of: searchText) { newValue in
                store.search(newValue)
            }
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        if store.state.isLoading {
            loadingView
        } else if let success = store.state.successState {
            successView(success)
        } else if let error = store.state.errorState {
            errorView(error.message)
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading Pokémon...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    private func successView(_ success: PokemonListState.Success) -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(success.pokemon, id: \.id) { pokemon in
                    NavigationLink(value: pokemon) {
                        PokemonGridCell(pokemon: pokemon)
                    }
                    .buttonStyle(.plain)
                }
                
                if success.canLoadMore {
                    loadMoreView(isLoading: success.isLoadingMore)
                }
            }
            .padding()
            .animation(.easeInOut(duration: 0.3), value: success.pokemon.count)
        }
        .refreshable {
            store.refresh()
        }
        .navigationDestination(for: Pokemon.self) { pokemon in
            PokemonDetailView(pokemonName: pokemon.name)
        }
    }
    
    private func loadMoreView(isLoading: Bool) -> some View {
        Group {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                Color.clear
                    .frame(height: 50)
                    .onAppear {
                        store.loadNextPage()
                    }
            }
        }
    }
    
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundStyle(.red)
            
            Text("Oops! Something went wrong")
                .font(.headline)
            
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: {
                store.refresh()
            }) {
                Label("Try Again", systemImage: "arrow.clockwise")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.accentColor)
                    .clipShape(Capsule())
            }
        }
    }
}

#Preview {
    PokemonListView()
}
