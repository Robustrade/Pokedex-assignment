//
//  PokemonStats.swift
//  iosApp
//
//  Created by vishwas on 4/3/26.
//

import SwiftUI
import shared

struct PokemonStatsSection: View {
    let detail: PokemonDetail
    let store: PokemonDetailStore

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Base Stats")
                .font(.headline)
                .padding(.horizontal)

            VStack(spacing: 6) {
                ForEach(detail.stats, id: \.name) { stat in
                    StatBarView(
                        label: store.shortStatName(stat.name),
                        value: stat.value
                    )
                }
            }
            .padding()
            .background(Color.cardBg)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .padding(.horizontal)
        }
        .padding(.bottom, 16)
    }
}
