import SwiftUI
import shared

@main
struct iOSApp: App {

    init() {
        ModulesKt.doInitKoin(
            driverFactory: DatabaseDriverFactory(),
            enableNetworkLogs: true
        ) { app in
            PokemonRepositoryResolver.retainKoinApplication(app)
        }
    }

    var body: some Scene {
        WindowGroup {
            let repository = PokemonRepositoryResolver.pokemonRepository()
            TabView {
                NavigationStack {
                    PokemonListScreen(repository: repository)
                }
                .tabItem {
                    Label("Pokédex", systemImage: "list.bullet")
                }

                NavigationStack {
                    FavoritesScreen(repository: repository)
                }
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
            }
        }
    }
}
