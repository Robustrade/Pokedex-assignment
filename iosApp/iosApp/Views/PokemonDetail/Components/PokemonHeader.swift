//
//  PokemonHeaderView.swift
//  iosApp
//
//  Created by vishwas on 4/3/26.
//

import SwiftUI
import shared

struct PokemonHeaderView: View {
    let detail: PokemonDetail
    let store: PokemonDetailStore
    
    var body: some View {
        VStack(spacing: 12) {
            let bgColor = detail.types.first
                .map { PokemonTypeColor.color(for: $0) } ?? .gray
            
            VStack {
                AsyncImage(url: URL(string: detail.imageUrl)) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFit().frame(height: 200)
                        
                    case .failure:
                        Image(systemName: "photo")
                            .font(.system(size: 60))
                            .foregroundStyle(.secondary)
                        
                    default:
                        ProgressView()
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 260)
            .background(bgColor.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .padding()
            
            Text(store.formattedId(detail.id))
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
            
            HStack(spacing: 8) {
                ForEach(detail.types, id: \.self) {
                    TypeChipView(type: $0)
                }
            }
        }
        .padding(.bottom, 16)
    }
}
