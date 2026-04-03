import SwiftUI

struct ContentView: View {

    var body: some View {
        TabView {
            NavigationStack {
                PokemonListView()
            }
            .tabItem {
                Label("Pokédex", systemImage: "square.grid.2x2.fill")
            }

            NavigationStack {
                FavoritesView()
            }
            .tabItem {
                Label("Favourites", systemImage: "heart.fill")
            }
        }
        .tint(.pokeBallRed)
    }
}
