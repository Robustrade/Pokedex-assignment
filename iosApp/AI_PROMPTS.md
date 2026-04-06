# AI-assisted development — iOS app (`iosApp`)


**Ground rules we kept**

- Treat **shared/** as provided: business logic, ViewModels stay in Kotlin unless the assignment says otherwise.
- Keep the **iOS layer thin**: SwiftUI observes Kotlin `StateFlow` / `Flow` and forwards actions; avoid duplicating repository logic in Swift.
- Consume **shared** via the **local CocoaPods** setup (`Podfile` + `shared/shared.podspec` → XCFramework from Gradle).

---

## Prompt 1 — KMP on macOS: wire the iOS app to `shared`

> I'm building a Kotlin Multiplatform app that already has a **`shared`** module. I need to wire the **iOS app** (SwiftUI) to that module: what should be consumed as a **CocoaPod** / XCFramework, what belongs in the **`Podfile`**, and what order of steps do I run (Gradle for `shared`, `pod install`, open workspace vs project)? Call out anything that commonly breaks (wrong workspace, stale framework, architecture slices on Apple Silicon CI). Also state if we can use SPM also?

**Intention**

- Get a **repeatable** path: build **`shared`** → integrate with Xcode → run without guessing workspace vs project or stale frameworks.

**Outcome**

- **Xcode** (SwiftUI / iOS build).
- **JDK 17** and **Gradle** at the repo root: build the **shared** XCFramework with `./gradlew` (e.g. `assembleSharedDebugXCFramework` / release as needed).
- **CocoaPods** (gem or Homebrew): `pod install` from **iosApp/**, then open **iosApp.xcworkspace** (not the `.xcodeproj` alone) so the **shared** pod and Pods project are visible.
- **CocoaPods vs SPM:** For **this** repo, integration is **CocoaPods**: the **shared** pod wraps the Gradle-built XCFramework and runs the expected pod install / build flow. **SPM** can consume **binary** XCFrameworks in some projects, but the standard path here is **not** switched to SPM—doing so would mean reworking how the framework is produced, packaged, and linked. We stayed on **Pods + local podspec** to match the assignment and CI.

---

## Prompt 2 — `PokemonRepository` on iOS (bridge, no `shared` edits)

> "PokemonRepository is a defined protocol, create a bridge to be used in the iOS application(don't make any changes."

**Intention**

- Expose the Kotlin **PokemonRepository** to Swift **without** changing **shared**, and understand options (helper module vs Koin-only).

**Outcome**

- The repo includes **iosInterop**: a small KMP module that depends on **shared** and can expose helpers such as **getPokemonRepository()** for setups that want a **single** clear entry point in some configurations.
- **PokemonRepository** is obtained via **ModulesKt.doInitKoin** via **PokemonRepositoryResolver.pokemonRepository()**, resolving from Koin—consistent with the “bridge from Swift” goal without editing **shared**.

---

## Prompt 3 — Resolver and making the repo available to Swift

> "Create a Resolver class to handle usage of iOSInterop and make repo available to iOS code"

**Intention**

- Centralize Koin / repository access so SwiftUI does not scatter lookups.

**Outcome**

- **PokemonRepositoryResolver.swift**: retains the **`KoinApplication`** after init and exposes **pokemonRepository()** for the rest of the app—one place to resolve **PokemonRepository** for screens and tests.
- Naming reflects the original ask (“resolver”); behavior matches **Koin + `shared`** only for this target.

---

## Prompt 4 — Motion + appearance (pagination, toggles, dark mode)

> "Define a AppMotion class with all animations needed for pagination, toggle of views, also define a class to handle dark mode"

**Intention**

- Shared **animation** constants for list/grid and transitions, and **type UI** that respects **light/dark** (not a single hard-coded palette).

**Outcome**

- **AppMotion** (`KotlinBridge.swift`): shared **Animation** values for list vs toggle-style motion.
- **PokemonTypePalette.swift**: maps Pokémon types to **trait-aware** (`UIColor` / dynamic) colors so chips read well in **light and dark** mode—this is the practical “dark mode” piece alongside system **Color** / **UIColor** APIs in SwiftUI.
- Consistent motion; type chips that track **Interface Style** instead of one fixed appearance.

---

## Prompt 5 — README for the iOS app

> "Create a readme and make it better that fully explains app and each component."

**Intention**

- **iosApp/README.md** should explain stack, layout, data flow, build/test, CI, troubleshooting if any.

**Outcome**

- **iosApp/README.md**: feature summary, stack table, repo layout, **mermaid** flow, per-file notes, build & test.
- Reviewers can onboard from **`iosApp/README.md`** without private context.

---

## Reflection — why this shape

- **Kotlin** owns API calls, pagination, SQLite, and ViewModels; **SwiftUI** focuses on UI, navigation, and **bridging**—clear assignment boundary.
- **Koin + one resolver** keeps dependency lookup predictable and avoids dual-framework mistakes.
- **Explicit flow bridges** (`StoreWrappers`, **`FlowCollectorHelper`**) make state easier to test and reason about than ad hoc observation.
