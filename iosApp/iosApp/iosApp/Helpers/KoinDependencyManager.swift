//
//  PokemonRespositoryManager.swift
//  iosApp
//
//  Created by Akash K on 12/04/26.
//

import shared

class KoinDependencyManager {
    static let shared = KoinDependencyManager()

    private let koin: Koin_coreKoin
    let repository: PokemonRepository

    private init() {
        var koinRef: Koin_coreKoin?

        ModulesKt.doInitKoin(
            driverFactory: DatabaseDriverFactory(),
            enableNetworkLogs: true,
            appDeclaration: { app in
                koinRef = app.koin
            }
        )

        guard let koinRef else {
            fatalError("failed to initialise koin")
        }

        koin = koinRef
        let instances = koin.instanceRegistry.instances
        var repoKotlinClass: KotlinKClass?

        for (_, factory) in instances {
            let primaryType = factory.beanDefinition.primaryType
            if primaryType.qualifiedName ==
                "com.assignment.pokemon.data.repository.PokemonRepository" {
                repoKotlinClass = primaryType
                break
            }
        }

        guard let repoKotlinClass,
              let repo = koin.get(clazz: repoKotlinClass, qualifier: nil, parameters: nil) as? PokemonRepository else {
            fatalError("PokemonRepository not found in Koin")
        }

        self.repository = repo
    }
}
