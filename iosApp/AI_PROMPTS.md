
## AI Usage Log

### Prompt 1 — Architecture planning
> *"Design an iOS architecture that safely bridges KMP StateFlow to SwiftUI, resolves Koin DI from Swift without modifying the shared module, and supports list/detail/favourites screens."*

**Used:** Store pattern, `StateFlowCollector`, `AsyncStream` extension, `ViewModelFactory` + `EnvironmentKey` shape.  
**Changed:** Replaced `DispatchQueue.main.async` with `await MainActor.run` throughout for structured concurrency consistency.

### Prompt 2 — Koin DI from Swift
> *"Koin's reified get<T>() doesn't work from Swift and I can't modify the shared module. How do I resolve PokemonRepository from the Koin container?"*

**Used:** `instanceRegistry.instances` iteration + `qualifiedName` match in `KoinDependencyManager`.  
**Changed:** Added `fatalError` guards for clearer startup failure messages.

### Prompt 3 — StateFlow AsyncStream bridge
> *"Build a type-safe Swift AsyncStream wrapper around Kotlinx_coroutines_coreFlowCollector for use with for-await loops."*

**Used:** `StateFlowCollector` + `stream(of:)` extension directly.  
**Changed:** Added `withExtendedLifetime(collector)` in `onTermination` to prevent premature ARC dealloc.

### Prompt 4 — Image caching
> *"Build a custom ObservableObject image loader with NSCache and retry logic, safe for @MainActor SwiftUI views."*

**Used:** `PokemonImageLoader` structure (cache lookup, retry loop, `URLSessionDataTask`).  
**Changed:** Switched to `Task { @MainActor in }` for actor isolation; added `hasFailed` for placeholder rendering.

### Prompt 5 — Detail screen layout
> *"Build a SwiftUI detail screen with: Swift Charts stat bars, abilities grid"*

**Used:** Decomposed view structure (`PokemonHeaderView`, `PokemonStatsSectionView`, `PokemonAbilitiesSectionView`), pulsing circle animation.  
**Changed:** Replaced `GeometryReader` header with `ZStack` + `HStack` overlay; switched abilities to `adaptive(minimum: 60)` grid for variable-length names. added a haptics feedback on favourites. minor UI tweaks to make it look good.

### Prompt 7 — TypeColors
> *"Map all 18 Pokémon types to SwiftUI Colors for type chips and background glows."*

**Used:** Type → colour dictionary directly.  
**Changed:** Adjusted Fire and Ghost colours to work better on dark mode.
