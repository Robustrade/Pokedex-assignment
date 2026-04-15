# iOS Assignment — PokéDex

## Repository

**`https://github.com/Robustrade/Pokedex-assignment`**

---

## Getting Started

### 1. Fork the repository

1. Open the repo link above and click **Fork** (top-right on GitHub).
2. Clone **your fork** locally:
   ```bash
   git clone git@github.com:<your-username>/Pokedex-assignment.git
   cd Pokedex-assignment
   ```
3. Create a feature branch — **do not commit directly to `main`**:
   ```bash
   git checkout -b ios/feature/<your-name>
   ```

### 2. Submit via Pull Request

When you are done:
1. Push your branch to your fork:
   ```bash
   git push origin ios/feature/<your-name>
   ```
2. Open a Pull Request from your fork's branch **→ `main`** on the original repo.
3. Use this PR title format: `[iOS] <your-name> — PokéDex Assignment`
4. In the PR description include:
   - A short summary of your implementation decisions
   - Screenshots or a screen recording of the app running
   - Any known limitations or things you would improve given more time
   - *(If AI was used)* the full list of prompts — see [AI Policy](#ai-policy) below

---

## Your Task

Build the iOS UI for the PokéDex app by integrating the `shared` KMP framework.
**Do not modify anything inside `shared/`.** That module is provided as-is.

### Screens to build

| Screen | ViewModel to use | Requirements |
|--------|-----------------|--------------|
| **Pokémon List** | `PokemonListViewModel` | Grid or list, search bar, infinite scroll / load-more |
| **Pokémon Detail** | `PokemonDetailViewModel(name:repo:)` | Image, type chips, base-stat bars, height/weight, favourite toggle |
| **Favourites** | `FavoritesViewModel` | Reactively updates when favourites change |

---

## Integration Guide

### Step 1 — Integrate the shared framework

**Option A — CocoaPods (recommended)**

Create `iosApp/Podfile`:
```ruby
use_frameworks!
platform :ios, '16.0'

target 'iosApp' do
  pod 'shared', :path => '../shared'
end
```
```bash
pod install
open iosApp.xcworkspace
```
The Gradle `syncFramework` task runs automatically before each Xcode build.

**Option B — XCFramework (manual)**

```bash
# from repo root
./gradlew :shared:assembleSharedXCFramework
```
Drag `shared/build/XCFrameworks/release/shared.xcframework` into your Xcode project target.

---

### Step 2 — Initialise Koin

In your `@main` App struct:
```swift
import shared

@main
struct iOSApp: App {
    init() {
        ModulesKt.doInitKoin(
            driverFactory: DatabaseDriverFactory(),
            enableNetworkLogs: true
        )
    }
    var body: some Scene {
        WindowGroup { ContentView() }
    }
}
```

---

### Step 3 — Observe StateFlow from SwiftUI

KMP `StateFlow` is not natively observable in SwiftUI. Create a thin `ObservableObject` wrapper:

```swift
import shared
import Combine

@MainActor
final class PokemonListStore: ObservableObject {
    @Published private(set) var state: PokemonListState = PokemonListState.Loading()

    private let viewModel: PokemonListViewModel
    private var task: Task<Void, Never>?

    init(repository: PokemonRepository) {
        viewModel = PokemonListViewModel(repository: repository)
        task = Task { [weak self] in
            // Collect the KMP StateFlow using an AsyncStream bridge
            for await newState in viewModel.state.stream() {
                self?.state = newState
            }
        }
    }

    func loadNextPage() { viewModel.loadNextPage() }
    func search(_ query: String) { viewModel.search(query: query) }

    deinit {
        task?.cancel()
        viewModel.onCleared()
    }
}
```

> **Tip:** Consider adding [KMPNativeCoroutines](https://github.com/rickclephas/KMP-NativeCoroutines)
> to get first-class `async/await` + `AsyncStream` wrappers for all KMP Flows with zero boilerplate.

---

## Evaluation Criteria

### Functional (60 pts)

| Area | Points |
|------|--------|
| Pokémon list with pagination | 15 |
| Search (live filtering) | 10 |
| Detail screen — all fields shown | 15 |
| Favourite toggle persists across app restarts | 10 |
| Favourites screen updates reactively | 10 |

### Code Quality (25 pts)

| Area | Points |
|------|--------|
| Clean SwiftUI patterns (no logic in Views) | 10 |
| Proper memory management (no retain cycles, StateFlow collected safely) | 8 |
| Consistent code style & naming | 7 |

### Git Discipline (15 pts)

| Area | Points |
|------|--------|
| Meaningful, atomic commit messages | 8 |
| Logical commit history (no "fix", "wip", "asdf" commits) | 4 |
| Clean PR description with screenshots | 3 |

### Bonus

| Bonus | Extra Points |
|-------|-------------|
| GitHub Actions CI (build + lint on every push) | +5 |
| Unit tests for the SwiftUI store/wrapper layer | +3 |
| Smooth animations (list transitions, type colour theming) | +2 |
| Dark mode support | +2 |

---

## GitHub Actions CI (Bonus)

Set up a workflow at `.github/workflows/ios.yml` that triggers on every push to your branch:

```yaml
name: iOS CI

on:
  push:
    branches: [ "ios/**" ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: macos-15

    steps:
      - uses: actions/checkout@v4

      - name: Set up JDK 17
        uses: actions/setup-java@v4
        with:
          java-version: '17'
          distribution: 'temurin'

      - name: Build shared XCFramework
        run: ./gradlew :shared:assembleSharedXCFramework

      - name: Install CocoaPods dependencies
        working-directory: iosApp
        run: pod install

      - name: Build iOS app (simulator)
        working-directory: iosApp
        run: |
          xcodebuild build \
            -workspace iosApp.xcworkspace \
            -scheme iosApp \
            -sdk iphonesimulator \
            -destination 'platform=iOS Simulator,name=iPhone 16' \
            CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO

      - name: Run tests
        working-directory: iosApp
        run: |
          xcodebuild test \
            -workspace iosApp.xcworkspace \
            -scheme iosApp \
            -sdk iphonesimulator \
            -destination 'platform=iOS Simulator,name=iPhone 16'
```

---

## AI Policy

You **may** use AI assistants (ChatGPT, Claude, Copilot, Cursor, etc.) to help complete this assignment.

**However, the following is mandatory if AI was used:**

1. Include a file `AI_PROMPTS.md` at the root of your `iosApp/` folder.
2. Log **every prompt** you sent to the AI in that file — copy-paste them in order.
3. Briefly note next to each prompt what you accepted, what you changed, and why.

**Example format:**
```markdown
## AI Prompts Log

### Prompt 1
> "How do I observe a KMP StateFlow in SwiftUI without KMPNativeCoroutines?"

**Used:** Yes, adapted the AsyncStream bridge pattern from the response.
**Changed:** Replaced the global actor usage with @MainActor on the class instead.

### Prompt 2
> "Write a SwiftUI grid view that shows a list of Pokemon with their image and name"

**Used:** Partially. Used the LazyVGrid structure, rewrote the cell to match the design spec.
```

Commit messages, code organisation, and the depth of understanding shown in your modifications to AI output will all be factored into the final score.

---

## Suggested Tech Stack

- **UI:** SwiftUI
- **Navigation:** `NavigationStack`
- **Images:** `AsyncImage` (built-in) or [Kingfisher](https://github.com/onevcat/Kingfisher)
- **KMP bridge:** Manual `ObservableObject` wrapper, or [KMPNativeCoroutines](https://github.com/rickclephas/KMP-NativeCoroutines)
- **Minimum deployment target:** iOS 16.0
