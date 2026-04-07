import shared

/// Singleton that initialises Koin and exposes the `PokemonRepository`
/// resolved from the DI container.
///
/// Usage: `KoinDependencies.shared.repository`
final class KoinDependencies {

    static let shared = KoinDependencies()

    let repository: PokemonRepository

    private let koin: Koin_coreKoin

    private init() {
        var koinRef: Koin_coreKoin!

        ModulesKt.doInitKoin(
            driverFactory: DatabaseDriverFactory(),
            enableNetworkLogs: true,
            appDeclaration: { app in
                koinRef = app.koin
            }
        )

        guard let koinInstance = koinRef else {
            fatalError("Koin failed to initialise")
        }
        self.koin = koinInstance

        // Resolve PokemonRepository by finding its KClass from Koin's
        // instance registry (the inline-reified `get<T>()` erases to Any
        // when called from Swift, so we use the class-based overload).
        let instances = koin.instanceRegistry.instances
        var repoKClass: KotlinKClass?

        for (_, factory) in instances {
            let primaryType = factory.beanDefinition.primaryType
            if primaryType.qualifiedName ==
                "com.assignment.pokemon.data.repository.PokemonRepository" {
                repoKClass = primaryType
                break
            }
        }

        guard let kclass = repoKClass,
              let repo = koin.get(clazz: kclass, qualifier: nil, parameters: nil)
                as? PokemonRepository
        else {
            fatalError("PokemonRepository not found in Koin")
        }

        self.repository = repo
    }
}
