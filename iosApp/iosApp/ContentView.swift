import SwiftUI
import shared

/// Root view hosting Pokédex and Favourites tabs.
struct ContentView: View {

    @State private var repository: PokemonRepository? = nil

    var body: some View {
        Group {
            if let repository {
                TabView {
                    PokemonListView(repository: repository)
                        .tabItem {
                            Label("Pokédex", systemImage: "square.grid.2x2.fill")
                        }

                    FavoritesView(repository: repository)
                        .tabItem {
                            Label("Favourites", systemImage: "heart.fill")
                        }
                }
                .tint(Theme.accentColor)
            } else {
                ProgressView("Starting…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .task {
            // Resolve Koin on first appear
            KoinHelper.start()
            repository = KoinHelper.getRepository()
        }
    }
}
