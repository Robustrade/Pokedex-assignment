import shared

/// Bridges a KMP `StateFlow` / `Flow` into a Swift callback.
///
/// Kotlin's `FlowCollector` protocol requires an `emit(value:completionHandler:)`
/// method. Each call to `completionHandler(nil)` resumes the coroutine so the
/// next value can be emitted.
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

extension Kotlinx_coroutines_coreStateFlow {

    /// Starts collecting the `StateFlow` and dispatches every new value to the
    /// main queue via `onChange`.  The collection never completes for a
    /// `StateFlow`; call `viewModel.onCleared()` to stop emissions.
    func observe<T>(as type: T.Type, onChange: @escaping (T) -> Void) {
        let collector = FlowCollector { value in
            if let typed = value as? T {
                DispatchQueue.main.async { onChange(typed) }
            }
        }
        // `collect` is a suspend function that never returns for StateFlow.
        // The completionHandler is only invoked on cancellation / error.
        self.collect(collector: collector) { _ in }
    }
}
