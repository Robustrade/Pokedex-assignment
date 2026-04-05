//
//  ContentView.swift
//  PokèDex
//
//  Created by Dharamrajsinh Jadeja on 04/04/26.
//

import SwiftUI
import shared

struct ContentView: View {
    @StateObject private var store = ContentView.makeStore()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }

    private static func makeStore() -> PokemonListStore {
        let koin = SharedKoin_coreKoinApplication.shared.koin
        guard let repository = koin.get() as? PokemonRepository else {
            fatalError("Unable to resolve PokemonRepository from Koin")
        }
        return PokemonListStore(repository: repository)
    }
}

#Preview {
    ContentView()
}
