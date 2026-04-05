import shared

/// Resolves `PokemonRepository` from Koin after `ModulesKt.doInitKoin` runs.
///
/// A Kotlin helper also exists in the `iosInterop` Gradle module (`getPokemonRepository`) for single-framework
/// setups. Linking both `shared` and `iosInterop` as CocoaPods frameworks duplicates Kotlin/Native symbols, so
/// this resolver stays Swift-only with the `shared` pod.
enum PokemonRepositoryResolver {
    private static var koinApplication: Koin_coreKoinApplication?

    static func retainKoinApplication(_ app: Koin_coreKoinApplication) {
        koinApplication = app
    }

    static func pokemonRepository() -> PokemonRepository {
        guard let koin = koinApplication?.koin else {
            fatalError("Koin not initialized — call retainKoinApplication from doInitKoin’s appDeclaration")
        }
        let pokemonRepositoryFqn = "com.assignment.pokemon.data.repository.PokemonRepository"
        let instances = koin.instanceRegistry.instances
        for (_, factoryObj) in instances {
            guard let factory = factoryObj as? Koin_coreInstanceFactory<AnyObject> else { continue }
            guard let qn = factory.beanDefinition.primaryType.qualifiedName, qn == pokemonRepositoryFqn else { continue }
            let clazz = factory.beanDefinition.primaryType
            if let repo = koin.getOrNull(clazz: clazz, qualifier: nil, parameters: nil) as? PokemonRepository {
                return repo
            }
        }
        fatalError("PokemonRepository not found in Koin")
    }
}
