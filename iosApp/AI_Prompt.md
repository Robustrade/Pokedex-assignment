# AI Prompts Log

This document logs every prompt sent to an AI assistant during development of the iOS PokéDex app, along with what was accepted, changed, and why.

---

## Prompt 1

> "I'm running `./gradlew :shared:assembleSharedXCFramework` but Gradle fails with _'Cannot locate tasks that match :shared:assembleSharedXCFramework'_. How do I build the shared XCFramework with the current KMP Gradle plugin?"

**Used:** Yes — adopted the aggregated task names.

**AI Response Summary:**
Modern Kotlin Multiplatform no longer exposes a single `assembleSharedXCFramework` task. It now generates configuration-specific variants:

```bash
# Debug
./gradlew :shared:assembleSharedDebugXCFramework

# Release
./gradlew :shared:assembleSharedReleaseXCFramework
```

Platform-specific tasks (e.g. `assembleDebugIosFatFrameworkForSharedXCFramework`) also exist but are unnecessary when the aggregated tasks are available.

**Changed:** Skipped the platform-specific tasks — the aggregated approach is simpler and aligns with the CocoaPods integration used in this project.

---

## Prompt 2

> "The Xcode build phase script fails with _'No such file or directory'_ when trying to run `gradlew`. The script uses `REPO_ROOT=\"$SRCROOT/..\"` and then calls `\"$REPO_ROOT/gradlew\"`. What's wrong?"

**Used:** Partially — accepted the root-cause diagnosis and the permissions fix, rejected the absolute-path workaround.

**AI Response Summary:**
Xcode's working directory during a build phase is `iosApp/`, so `$SRCROOT/..` must correctly resolve to the repository root where `gradlew` lives. Two things to verify:

1. **`gradlew` exists at the repo root** — if the Gradle wrapper was never generated, run:
   ```bash
   gradle wrapper --gradle-version 8.7
   ```
2. **`gradlew` is executable** — fix with:
   ```bash
   chmod +x ./gradlew
   ```

The AI also suggested hard-coding an absolute path (`REPO_ROOT="/Users/.../Pokedex-assignment"`) as a fallback.

**Changed:** Ignored the absolute-path suggestion to keep the project portable and repo-friendly. Only applied the wrapper generation and `chmod +x` fix.

---

## Prompt 3

> "After fixing the `gradlew` path, the CocoaPods build phase now fails with _'Cannot locate tasks that match :shared:syncFramework as task syncFramework not found in project :shared'_. How do I update the script for the current KMP plugin?"

**Used:** Yes — replaced the deprecated `syncFramework` invocation with the configuration-aware XCFramework task.

**AI Response Summary:**
The `syncFramework` task was removed in newer KMP versions. The build-phase script should be updated from:

```bash
"$REPO_ROOT/gradlew" -p "$REPO_ROOT" :shared:syncFramework \
  -Pkotlin.native.cocoapods.platform=$PLATFORM_NAME \
  -Pkotlin.native.cocoapods.archs="$ARCHS" \
  -Pkotlin.native.cocoapods.configuration="$CONFIGURATION"
```

To:

```bash
"$REPO_ROOT/gradlew" -p "$REPO_ROOT" :shared:assembleShared${CONFIGURATION}XCFramework \
  -Pkotlin.native.cocoapods.platform=$PLATFORM_NAME \
  -Pkotlin.native.cocoapods.archs="$ARCHS"
```

`${CONFIGURATION}` resolves to `Debug` or `Release` at build time, so the task name itself encodes the build type and the `-Pkotlin.native.cocoapods.configuration` flag is no longer needed.

**Changed:** Also removed the now-unnecessary `configuration` flag to keep the script clean.

---

## Prompt 4

> "How do I initialise Koin from Swift and resolve `PokemonRepository`? The KMP shared module exposes `doInitKoin(driverFactory:enableNetworkLogs:)` but Koin's `get<T>()` is an inline-reified function — calling it from Swift erases the type to `Any`. How can I get a typed reference to the repository?"

**Used:** Yes — built the `KoinDependencies` singleton based on the suggested approach.

**AI Response Summary:**
Because Kotlin's `inline reified` generics are erased when called from Swift, you cannot use `koin.get<PokemonRepository>()` directly. Two approaches:

1. **Walk the instance registry** — iterate `koin.instanceRegistry.instances`, match on the bean's `primaryType.qualifiedName`, then call the class-based `koin.get(clazz:qualifier:parameters:)` overload.
2. **Add a helper in the shared module** — expose a plain Kotlin function like `fun getPokemonRepository(koin: Koin): PokemonRepository = koin.get()` so the reified call happens on the Kotlin side.

The AI also recommended capturing the `Koin` instance during initialisation via the `appDeclaration` closure:

```swift
var koinRef: Koin_coreKoin!

ModulesKt.doInitKoin(
    driverFactory: DatabaseDriverFactory(),
    enableNetworkLogs: true,
    appDeclaration: { app in
        koinRef = app.koin
    }
)
```

**Changed:** Went with Option 1 (registry walk) since the assignment says _"Do not modify anything inside `shared/`"_. Wrapped everything in a `KoinDependencies` singleton so Koin is initialised exactly once at app launch and the repository is available via `KoinDependencies.shared.repository`.

---

## Prompt 5

> "How do I observe a KMP `StateFlow` from SwiftUI? The shared ViewModels expose `val state: StateFlow<PokemonListState>` but SwiftUI doesn't natively understand Kotlin coroutines. I can't use KMP-NativeCoroutines — what's the manual approach?"

**Used:** Yes — implemented the `FlowCollector` class and the `observe(as:onChange:)` extension.

**AI Response Summary:**
Kotlin's `Flow.collect()` is a suspend function that expects a `FlowCollector` protocol implementation. From Swift you can bridge this manually:

1. **Create a `FlowCollector`** that conforms to `Kotlinx_coroutines_coreFlowCollector`. Its `emit(value:completionHandler:)` method receives each value; calling `completionHandler(nil)` resumes the coroutine for the next emission:

```swift
final class FlowCollector: NSObject, Kotlinx_coroutines_coreFlowCollector {
    private let onEmit: (Any?) -> Void

    init(_ onEmit: @escaping (Any?) -> Void) {
        self.onEmit = onEmit
    }

    func emit(value: Any?, completionHandler: @escaping (Error?) -> Void) {
        onEmit(value)
        completionHandler(nil)
    }
}
```

2. **Add a typed convenience extension** on `Kotlinx_coroutines_coreStateFlow` that creates a collector, casts the emitted value to the expected type, and dispatches to the main queue:

```swift
extension Kotlinx_coroutines_coreStateFlow {
    func observe<T>(as type: T.Type, onChange: @escaping (T) -> Void) {
        let collector = FlowCollector { value in
            if let typed = value as? T {
                DispatchQueue.main.async { onChange(typed) }
            }
        }
        self.collect(collector: collector) { _ in }
    }
}
```

3. **In each `ObservableObject` store**, call `viewModel.state.observe(as:onChange:)` during init. Use `[weak self]` in the closure to avoid retain cycles. Call `viewModel.onCleared()` in `deinit` to cancel the underlying coroutine scope — this is the only way to stop collection since `StateFlow.collect` never completes on its own.

The AI also suggested an alternative `AsyncStream`-based bridge using Swift concurrency, but noted it requires more boilerplate for cancellation handling.

**Changed:** Chose the callback-based approach over `AsyncStream` — it's simpler, has no `Task` lifecycle to manage, and works cleanly with `@Published` properties. Added `DispatchQueue.main.async` inside the collector to guarantee UI updates happen on the main thread. Also loaded the initial `StateFlow` value synchronously via `viewModel.state.value` before starting observation to avoid a blank frame on first render.

---

## Outcome

All three build issues (Prompts 1–3) stemmed from the KMP Gradle plugin version moving past the APIs in the original template. Prompts 4–5 covered the core KMP ↔ Swift integration layer:

- XCFramework builds successfully for both Debug and Release
- CocoaPods integration works correctly with the Xcode build phase
- Koin initialisation and dependency resolution works from Swift without modifying the shared module
- KMP `StateFlow` is observable from SwiftUI via a lightweight `FlowCollector` bridge
- The project is aligned with modern KMP + CocoaPods practices