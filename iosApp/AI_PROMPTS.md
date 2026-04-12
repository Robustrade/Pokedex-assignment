## AI Prompts Log

### Prompt 1
> "Complete the PokéDex iOS assignment — build the SwiftUI iOS app integrating the shared KMP framework. Plan first, then implement all screens (List, Detail, Favourites) with proper StateFlow bridging, Koin integration, pagination, search, favourites persistence, animations, dark mode, and CI."

**Used:** Yes — used the overall architecture plan and file structure.
**Changed:** Refined the KoinHelper implementation after inspecting generated ObjC headers from the shared framework. Adjusted FlowCollector to match the actual Kotlin/Native interop API. Modified navigation pattern to pass repository instances directly instead of environment objects for simpler lifecycle management.

### Prompt 2
> (Follow-up implementation executed within the same conversation)

All code was generated in a single iterative session. The following manual refinements were applied:
- Verified shared framework API surface by reading all Kotlin source files
- Adapted sealed class pattern matching to use `onEnum(of:)` for KMP interop
- Fixed memory management with proper `[weak self]` captures and Task cancellation
- Ensured `onCleared()` is called on KMP ViewModels in Swift `deinit`
