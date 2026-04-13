//
//  DetailsView.swift
//  iosApp
//
//  Created by Akash K on 12/04/26.
//

import SwiftUI
import shared
import Charts

struct DetailsView: View {
    let name: String
    @StateObject private var viewModel: DetailsViewModel
    @State private var isPulsing = false
    
    init(name: String, viewModel: @escaping (String) -> DetailsViewModel) {
        self.name = name
        _viewModel = StateObject(wrappedValue: viewModel(name))
    }
    
    private let bgFill = Color(uiColor: UIColor.secondarySystemBackground)
    
    var body: some View {
        Group {
            switch viewModel.detailState {
            case is PokemonDetailState.Loading:
                ProgressView()
            case let success as PokemonDetailState.Success:
                let pokemonDetail = success.pokemon
                ScrollView {
                    VStack(spacing: 12) {
                        ZStack(alignment: .center) {
                            AsyncImage(
                                url: URL(string: pokemonDetail.imageUrl)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 200)
                                        .background {
                                            Circle()
                                                .fill(TypeColors.background(for: pokemonDetail.types.first))
                                                .blur(radius: 40)
                                                .scaleEffect(isPulsing ? 1.2 : 0.8)
                                                .frame(width: .infinity, height: .infinity)
                                                .onAppear {
                                                    withAnimation(
                                                        .easeIn(duration: 2)
                                                        .repeatForever(autoreverses: true)
                                                    ) {
                                                        isPulsing = true
                                                    }
                                                }.onDisappear {
                                                    isPulsing = false
                                                }
                                        }
                                        .transition(.opacity)
                                } placeholder: {
                                    Image(systemName: "photo.badge.exclamationmark")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 200)
                                }
                                
                            
                            HStack {
                                DimensionView(pokemonDetail: pokemonDetail)
                                Spacer()
                            }
                        }
                        .frame(maxWidth: .infinity)

                        pokemonTypeView(pokemonDetail: pokemonDetail)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            sectionTitle("Stats").padding()
                            StatsView(pokemonDetail: pokemonDetail)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .strokeBorder(.quaternary, lineWidth: 1)
                        )
                        
                        abilitySection(pokemonDetail)
                        
                    }
                }
                .scrollIndicators(.hidden)
                .padding(.horizontal)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            viewModel.toggleFavourite()
                        } label: {
                            Image(systemName: pokemonDetail.isFavorite ? "heart.fill" : "heart")
                        }
                    }
                }
                .navigationTitle(pokemonDetail.name.capitalized)
                .navigationBarTitleDisplayMode(.inline)
            case let error as PokemonDetailState.Error:
                Text(error.message)
            default:
                EmptyView()
            }
        }
    }
    
    @ViewBuilder
    func pokemonTypeView(pokemonDetail: PokemonDetail) -> some View {
        HStack(spacing: 8) {
            ForEach(pokemonDetail.types, id: \.self) { type in
                TypeChipView(type: type)
            }
        }
    }
    
    func abilitySection(_ pokemonDetail: PokemonDetail) -> some View {
        let abilityColumns = [
            GridItem(.adaptive(minimum: 120), spacing: 8, alignment: .leading)
        ]

        return VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Abilities")

            LazyVGrid(columns: abilityColumns, alignment: .leading, spacing: 8) {
                ForEach(pokemonDetail.abilities, id: \.self) { ability in
                    Text(ability.replacingOccurrences(of: "-", with: " ").capitalized)
                        .font(.subheadline.weight(.medium))
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.ultraThinMaterial)
                        )
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(.quaternary, lineWidth: 1)
        )
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
