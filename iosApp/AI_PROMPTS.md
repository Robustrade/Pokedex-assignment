### Prompt 1
> "I want to setup KMP structured  application for iOS on mac, there are some shared resources, what needs to used as a pod in iOS app. Guide me steps for the setup."

**Used:**
- Xcode (SwiftUI / iOS build).
- JDK 17 + Gradle — the shared XCFramework is built with ./gradlew from the repo root (as in iosApp/README.md).
- CocoaPods (gem install cocoapods or Homebrew).

### Prompt 2
> "PokemonRepository is a defined protocol, create a bridge to be used in the iOS application(don't make any changes."

**Used:**
- created a iosInterop: small KMP module that depends on shared and offers getPokemonRepository() for non–dual-framework iOS setups.

### Prompt 3
> "Create a Resolver class to handle usage of iOSInterop and make repo available to iOS code"

**Used:**
- created PokemonRepositoryResolver

### Prompt 4
> "Define a AppMotion class with all animations needed for pagination, toggle of views, also define a class to handle dark mode"
**Used:** 
- defined a PokemonTypePalette

### Prompt 5
> "Create a readme and make it better that fully explains app and each component."
