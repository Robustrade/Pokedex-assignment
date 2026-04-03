import SwiftUI

struct RootTabView: View {

    var body: some View {
        TabView {
            NavigationStack {
                PokemonListView()
                    .navigationDestination(for: String.self) { name in
                        PokemonDetailView(pokemonName: name)
                    }
            }
            .tabItem {
                Label("Pokédex", systemImage: "square.grid.2x2.fill")
            }

            NavigationStack {
                FavoritesView()
                    .navigationDestination(for: String.self) { name in
                        PokemonDetailView(pokemonName: name)
                    }
            }
            .tabItem {
                Label("Favourites", systemImage: "heart.fill")
            }
        }
        .tint(.pokeBallRed)
    }
}
