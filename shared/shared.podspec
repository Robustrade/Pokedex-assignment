Pod::Spec.new do |spec|
    spec.name                     = 'shared'
    spec.version                  = '1.0.0'
    spec.homepage                 = 'https://github.com/Robustrade/Pokedex-assignment'
    spec.source                   = { :path => '.' }
    spec.authors                  = 'Pokemon Assignment'
    spec.license                  = { :type => 'MIT' }
    spec.summary                  = 'PokemonKMP Shared Module'
    spec.ios.deployment_target    = '16.0'

    spec.vendored_frameworks      = 'build/XCFrameworks/debug/shared.xcframework'
    
    spec.libraries                = 'c++', 'sqlite3'
    spec.static_framework         = true

    spec.pod_target_xcconfig = {
        'KOTLIN_PROJECT_PATH' => ':shared',
        'PRODUCT_MODULE_NAME' => 'shared',
    }
end
