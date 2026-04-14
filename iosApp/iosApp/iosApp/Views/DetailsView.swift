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
    private let hapticsManager: HapticsProviding

    init(
        name: String,
        viewModel: @escaping (String) -> DetailsViewModel,
        hapticsManager: HapticsProviding = HapticsManager.shared
    ) {
        self.name = name
        self.hapticsManager = hapticsManager
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
                            let willBecomeFavourite = !pokemonDetail.isFavorite
                            viewModel.toggleFavourite()
                            if willBecomeFavourite {
                                hapticsManager.favouriteAdded()
                            }
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
        .onAppear {
            viewModel.retry()
        }
    }
}

struct PokemonHeaderView: View {
    let pokemonDetail: PokemonDetail

    var body: some View {
        ZStack(alignment: .center) {

            VStack(spacing: 0) {
                Text(PokemonDisplayFormatter.formattedID(pokemonDetail.id))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(
                        Capsule()
                            .stroke(.secondary.opacity(0.4), lineWidth: 1)
                    )
                    .padding(8)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

                PokemonImageView(imageUrl: pokemonDetail.imageUrl, firstType: pokemonDetail.types.first)
            }

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
    @StateObject private var imageLoader: PokemonImageLoader
    @State private var isPulsing = false

    init(imageUrl: String, firstType: String?) {
        self.imageUrl = imageUrl
        self.firstType = firstType
        _imageLoader = StateObject(wrappedValue: PokemonImageLoader(urlString: imageUrl))
    }

    var body: some View {
        imageContent
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
            .task {
                imageLoader.loadIfNeeded()
            }
    }

    @ViewBuilder
    private var imageContent: some View {
        if let uiImage = imageLoader.image {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else if imageLoader.isLoading {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            Image(systemName: imageLoader.hasFailed ? "photo.badge.exclamationmark" : "photo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.secondary)
                .padding(40)
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

struct SectionTitleView: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
