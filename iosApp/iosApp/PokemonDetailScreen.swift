import SwiftUI
import shared

// MARK: - Screen (uses shared `PokemonDetailViewModel` via `PokemonDetailScreenModel`)

struct PokemonDetailScreen: View {
    @StateObject private var model: PokemonDetailScreenModel

    init(pokemonName: String, repository: PokemonRepository) {
        _model = StateObject(wrappedValue: PokemonDetailScreenModel(pokemonName: pokemonName, repository: repository))
    }

    var body: some View {
        Group {
            switch model.state {
            case is PokemonDetailState.Loading:
                loadingView

            case let success as PokemonDetailState.Success:
                detailScroll(pokemon: success.pokemon)

            case let error as PokemonDetailState.Error:
                errorView(message: error.message)

            default:
                EmptyView()
            }
        }
        .navigationTitle(model.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("Loading…")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundStyle(.red)
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            Button("Retry") { model.retry() }
                .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func detailScroll(pokemon: PokemonDetail) -> some View {
        let types = PokemonDetailFormatting.stringArray(from: pokemon.types)
        let stats = PokemonDetailFormatting.statArray(from: pokemon.stats)
        let abilities = PokemonDetailFormatting.stringArray(from: pokemon.abilities)

        return ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerImage(url: String(pokemon.imageUrl))

                HStack {
                    Text("#\(String(format: "%03d", pokemon.id))")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
                    Spacer()
                    favoriteButton(isFavorite: pokemon.isFavorite)
                }

                Text("Types")
                    .font(.headline)
                typeChips(types: types)

                metricsRow(heightDm: pokemon.height, weightHg: pokemon.weight)

                Text("Base stats")
                    .font(.headline)
                statBars(stats: stats)

                if !abilities.isEmpty {
                    Text("Abilities")
                        .font(.headline)
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(Array(abilities.enumerated()), id: \.offset) { _, ability in
                            Text(ability.replacingOccurrences(of: "-", with: " ").capitalized)
                                .font(.subheadline)
                        }
                    }
                }
            }
            .padding()
        }
    }

    private func headerImage(url: String) -> some View {
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .frame(height: 220)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 260)
            case .failure:
                Image(systemName: "photo")
                    .font(.system(size: 64))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, minHeight: 180)
            @unknown default:
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity)
    }

    private func favoriteButton(isFavorite: Bool) -> some View {
        Button {
            withAnimation(AppMotion.toggle) {
                model.toggleFavorite()
            }
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(.title2)
                .foregroundStyle(isFavorite ? Color.red : Color.secondary)
        }
        .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
    }

    private func typeChips(types: [String]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Array(types.enumerated()), id: \.offset) { _, raw in
                    Text(raw.capitalized)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(PokemonTypePalette.color(for: raw.lowercased()))
                        .shadow(color: .black.opacity(0.12), radius: 2, x: 0, y: 1)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }
            }
        }
    }

    private func metricsRow(heightDm: Int32, weightHg: Int32) -> some View {
        let heightM = PokemonDetailFormatting.heightMeters(fromDecimeters: heightDm)
        let weightKg = PokemonDetailFormatting.weightKg(fromHectograms: weightHg)
        return HStack(spacing: 24) {
            Label {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Height")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(String(format: "%.1f m", heightM))
                        .font(.body)
                        .fontWeight(.medium)
                }
            } icon: {
                Image(systemName: "ruler")
                    .foregroundStyle(.blue)
            }
            Label {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Weight")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(String(format: "%.1f kg", weightKg))
                        .font(.body)
                        .fontWeight(.medium)
                }
            } icon: {
                Image(systemName: "scalemass")
                    .foregroundStyle(.orange)
            }
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func statBars(stats: [PokemonStat]) -> some View {
        let maxVal = PokemonDetailFormatting.maxStatValue(for: stats)
        return VStack(alignment: .leading, spacing: 10) {
            ForEach(Array(stats.enumerated()), id: \.offset) { _, stat in
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(PokemonDetailFormatting.statDisplayName(String(stat.name)))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text("\(stat.value)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .monospacedDigit()
                    }
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color(.tertiarySystemFill))
                            Capsule()
                                .fill(Color.accentColor.opacity(0.85))
                                .frame(width: geo.size.width * CGFloat(Int(stat.value)) / CGFloat(maxVal))
                        }
                    }
                    .frame(height: 8)
                }
            }
        }
    }
}
