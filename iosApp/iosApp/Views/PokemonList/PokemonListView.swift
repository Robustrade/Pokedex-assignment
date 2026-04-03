import SwiftUI
import shared


struct PokemonListView: View {
    
    @StateObject private var store = PokemonListStore()
    @State private var searchText = ""
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        ZStack {
            Color.screenBg.ignoresSafeArea()
            
            Group {
                switch store.state {
                case is PokemonListState.Loading:
                    ProgressView("Loading Pokémon…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                case let success as PokemonListState.Success:
                    PokemonGridView(
                        success: success,
                        columns: columns,
                        store: store
                    )
                    
                case let error as PokemonListState.Error:
                    PokemonListErrorView(
                        message: error.message,
                        onRetry: store.refresh
                    )
                    
                default:
                    EmptyView()
                }
            }
        }
        .navigationTitle("Pokédex")
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search Pokémon"
        )
        .onChange(of: searchText) { newValue in
            store.search(newValue)
        }
    }
}
