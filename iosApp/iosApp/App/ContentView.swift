import SwiftUI
import shared

struct ContentView: View {
    @State private var selectedTab: Tab = .list
    
    var body: some View {
        TabView(selection: $selectedTab) {
            PokemonListView()
                .tabItem {
                    Label("Pokédex", systemImage: "list.bullet.rectangle")
                }
                .tag(Tab.list)
            
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
                .tag(Tab.favorites)
        }
        .tint(PokemonColors.primary)
    }
}

enum Tab: Hashable {
    case list
    case favorites
}

#Preview {
    ContentView()
}
