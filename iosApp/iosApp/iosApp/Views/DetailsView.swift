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
                        PokemonHeaderView(pokemonDetail: pokemonDetail)
                        
                        PokemonTypeListView(types: pokemonDetail.types)
                        
                        PokemonStatsSectionView(pokemonDetail: pokemonDetail)
                        
                        PokemonAbilitiesSectionView(abilities: pokemonDetail.abilities)
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
}

struct PokemonHeaderView: View {
    let pokemonDetail: PokemonDetail
    
    var body: some View {
        ZStack(alignment: .center) {
            PokemonImageView(imageUrl: pokemonDetail.imageUrl, firstType: pokemonDetail.types.first)
            
            HStack {
                DimensionView(pokemonDetail: pokemonDetail)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct PokemonImageView: View {
    let imageUrl: String
    let firstType: String?
    @State private var isPulsing = false
    
    var body: some View {
        AsyncImage(url: URL(string: imageUrl)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
                .background {
                    Circle()
                        .fill(TypeColors.background(for: firstType))
                        .blur(radius: 40)
                        .scaleEffect(isPulsing ? 1.2 : 0.8)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onAppear {
                            withAnimation(
                                .easeIn(duration: 2)
                                .repeatForever(autoreverses: true)
                            ) {
                                isPulsing = true
                            }
                        }
                        .onDisappear {
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
    }
}

struct PokemonTypeListView: View {
    let types: [String]
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(types, id: \.self) { type in
                TypeChipView(type: type)
            }
        }
    }
}

struct PokemonStatsSectionView: View {
    let pokemonDetail: PokemonDetail
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionTitleView(title: "Stats")
                .padding(.leading)
                .padding(.top)
            StatsView(pokemonDetail: pokemonDetail)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(.quaternary, lineWidth: 1)
        )
    }
}

struct PokemonAbilitiesSectionView: View {
    let abilities: [String]
    
    private let abilityColumns = [
        GridItem(.adaptive(minimum: 120), spacing: 8, alignment: .leading)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitleView(title: "Abilities")

            LazyVGrid(columns: abilityColumns, alignment: .leading, spacing: 8) {
                ForEach(abilities, id: \.self) { ability in
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
}

struct SectionTitleView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
