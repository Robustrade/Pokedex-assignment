import SwiftUI
import shared

/// Detail screen for a single Pokémon showing image, types, stats,
/// height/weight, abilities, and a favourite toggle.
struct PokemonDetailView: View {

    @StateObject private var store: PokemonDetailStore
    @Environment(\.dismiss) private var dismiss

    init(pokemonName: String, repository: PokemonRepository) {
        _store = StateObject(
            wrappedValue: PokemonDetailStore(
                pokemonName: pokemonName,
                repository: repository
            )
        )
    }

    var body: some View {
        Group {
            if store.state is PokemonDetailState.Loading {
                ProgressView("Loading…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorState = store.state as? PokemonDetailState.Error {
                errorView(message: errorState.message)
            } else if let successState = store.state as? PokemonDetailState.Success {
                detailContent(successState.pokemon)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Error

    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text(message)
                .foregroundStyle(.secondary)
            Button("Retry") { store.retry() }
                .buttonStyle(.borderedProminent)
                .tint(Theme.accentColor)
        }
    }

    // MARK: - Detail Content

    private func detailContent(_ pokemon: PokemonDetail) -> some View {
        let primaryType = (pokemon.types as? [String])?.first ?? "normal"

        return ScrollView {
            VStack(spacing: 20) {
                headerSection(pokemon, primaryType: primaryType)
                typeChipsSection(pokemon)
                physicalSection(pokemon)
                statsSection(pokemon)
                abilitiesSection(pokemon)
            }
            .padding(.bottom, 32)
        }
        .background(TypeColors.background(for: primaryType).ignoresSafeArea())
        .navigationTitle(Theme.pokemonName(pokemon.name))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                favouriteButton(pokemon)
            }
        }
    }

    // MARK: - Header

    private func headerSection(_ pokemon: PokemonDetail, primaryType: String) -> some View {
        VStack(spacing: 8) {
            Text(Theme.pokemonId(Int(pokemon.id)))
                .font(.system(.headline, design: .monospaced))
                .foregroundStyle(.secondary)

            AsyncImage(url: URL(string: pokemon.imageUrl)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure:
                    Image(systemName: "photo")
                        .font(.system(size: 64))
                        .foregroundStyle(.secondary)
                default:
                    ProgressView()
                }
            }
            .frame(width: 220, height: 220)
            .shadow(color: TypeColors.color(for: primaryType).opacity(0.4),
                    radius: 20, x: 0, y: 10)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
    }

    // MARK: - Type chips

    private func typeChipsSection(_ pokemon: PokemonDetail) -> some View {
        let types = pokemon.types as? [String] ?? []
        return HStack(spacing: 10) {
            ForEach(types, id: \.self) { type in
                TypeChipView(type: type)
            }
        }
    }

    // MARK: - Height / Weight

    private func physicalSection(_ pokemon: PokemonDetail) -> some View {
        HStack(spacing: 32) {
            infoCard(
                icon: "ruler",
                title: "Height",
                value: Theme.formattedHeight(Int(pokemon.height))
            )
            infoCard(
                icon: "scalemass",
                title: "Weight",
                value: Theme.formattedWeight(Int(pokemon.weight))
            )
        }
        .padding(.horizontal)
    }

    private func infoCard(icon: String, title: String, value: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.system(.title3, weight: .bold))
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: Theme.cardCornerRadius, style: .continuous)
                .fill(.ultraThinMaterial)
        )
    }

    // MARK: - Stats

    private func statsSection(_ pokemon: PokemonDetail) -> some View {
        let stats = pokemon.stats as? [PokemonStat] ?? []
        return VStack(alignment: .leading, spacing: 10) {
            Text("Base Stats")
                .font(.system(.headline, weight: .bold))
                .padding(.horizontal)

            VStack(spacing: 8) {
                ForEach(stats, id: \.name) { stat in
                    StatBarView(
                        statName: stat.name,
                        value: Int(stat.value),
                        maxValue: 255
                    )
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: Theme.cardCornerRadius, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
            .padding(.horizontal)
        }
    }

    // MARK: - Abilities

    private func abilitiesSection(_ pokemon: PokemonDetail) -> some View {
        let abilities = pokemon.abilities as? [String] ?? []
        guard !abilities.isEmpty else { return AnyView(EmptyView()) }
        return AnyView(
            VStack(alignment: .leading, spacing: 10) {
                Text("Abilities")
                    .font(.system(.headline, weight: .bold))
                    .padding(.horizontal)

                HStack(spacing: 10) {
                    ForEach(abilities, id: \.self) { ability in
                        Text(ability.replacingOccurrences(of: "-", with: " ").capitalized)
                            .font(.subheadline)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                Capsule().fill(.ultraThinMaterial)
                            )
                    }
                }
                .padding(.horizontal)
            }
        )
    }

    // MARK: - Favourite

    private func favouriteButton(_ pokemon: PokemonDetail) -> some View {
        Button {
            withAnimation(.spring(response: 0.3)) {
                store.toggleFavorite()
            }
        } label: {
            Image(systemName: pokemon.isFavorite ? "heart.fill" : "heart")
                .font(.title3)
                .foregroundStyle(pokemon.isFavorite ? .red : .secondary)
        }
    }
}
