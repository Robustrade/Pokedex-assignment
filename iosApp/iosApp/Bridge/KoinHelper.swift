import shared

/// Thin Swift wrapper around the Koin DI container.
/// Call `KoinHelper.start()` once at app launch, then resolve
/// dependencies through the static helpers.
@MainActor
enum KoinHelper {

    // MARK: - Bootstrap

    private static var isStarted = false

    /// Initialise the shared Koin graph.
    static func start() {
        guard !isStarted else { return }
        isStarted = true
        
        ModulesKt.doInitKoin(
            driverFactory: DatabaseDriverFactory(),
            enableNetworkLogs: true,
            appDeclaration: { app in
                self.koinApp = app
                app.modules(modules_: [ModulesKt.viewModelModule])
                
                print("--- KOIN MAPPINGS ---")
                if let mappings = app.koin.instanceRegistry.instances as? [String: Any] {
                    for key in mappings.keys {
                        print("Koin key: \(key)")
                    }
                }
                print("---------------------")
            }
        )
    }

    // MARK: - Resolution
    
    /// Retrieves a Dependency from Koin by fuzzy-matching the class name in the registry entries
    /// to obtain the underlying `SharedKotlinKClass`. This circumvents the fact that ObjC `get()`
    /// functions crash when the KClass is erased.
    private static func resolve<T>(className: String) -> T {
        guard let koinApp = koinApp else {
            fatalError("Koin has not been started.")
        }
        
        let koin = koinApp.koin
        guard let mappings = koin.instanceRegistry.instances as? [String: Koin_coreInstanceFactory<AnyObject>] else {
            fatalError("Could not cast Koin instance registry.")
        }
        
        guard let key = mappings.keys.first(where: { $0.contains(className) }),
              let factory = mappings[key] else {
            fatalError("Could not find factory for \(className).")
        }
        
        let kClass = factory.beanDefinition.primaryType
        
        // Pass the extracted class back to Koin
        guard let instance = koin.get(clazz: kClass, qualifier: nil, parameters: nil) as? T else {
            fatalError("Could not resolve instance for \(className).")
        }
        
        return instance
    }

    static func getRepository() -> PokemonRepository {
        return resolve(className: "PokemonRepository")
    }

    // MARK: - Private

    /// Cached reference to the global KoinApplication instance.
    private nonisolated(unsafe) static var koinApp: Koin_coreKoinApplication?
}
