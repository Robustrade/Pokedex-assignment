//
//  PokemonError.swift
//  iosApp
//
//  Created by vishwas on 4/3/26.
//

import SwiftUI
import shared

struct PokemonErrorView: View {
    let message: String
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)

            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button("Retry", action: onRetry)
                .buttonStyle(.borderedProminent)
                .tint(.pokeBallRed)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
