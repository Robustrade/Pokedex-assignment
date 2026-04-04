Pod::Spec.new do |spec|
    spec.name                     = 'shared'
    spec.version                  = '1.0.0'
    spec.homepage                 = ''
    spec.homepage                 = 'https://example.com'
    spec.source                   = { :path => '.' }
    spec.authors                  = ''
    spec.summary                  = 'PokemonKMP Shared Module'
    spec.ios.deployment_target    = '16.0'

    spec.vendored_frameworks      = 'build/cocoapods/framework/shared.framework'

    spec.pod_target_xcconfig = {
        'KOTLIN_PROJECT_PATH' => ':shared',
        'PRODUCT_MODULE_NAME' => 'shared',
    }

    spec.script_phases = [
        {
            :name               => 'Build shared',
            :execution_position => :before_compile,
            :shell_path         => '/bin/sh',
            :script             => <<-SCRIPT
                if [ "YES" = "$OVERRIDE_KOTLIN_BUILD_IDE_SUPPORTED" ]; then
                    echo "Skipping Kotlin build task invocation due to OVERRIDE_KOTLIN_BUILD_IDE_SUPPORTED"
                    exit 0
                fi
                set -ev
                REPO_ROOT="$SRCROOT/.."
                "$REPO_ROOT/gradlew" -p "$REPO_ROOT" :shared:syncFramework \
                    -Pkotlin.native.cocoapods.platform=$PLATFORM_NAME \
                    -Pkotlin.native.cocoapods.archs="$ARCHS" \
                    -Pkotlin.native.cocoapods.configuration="$CONFIGURATION"
            SCRIPT
        }
    ]
end
