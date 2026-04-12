import shared

/// Bridges a KMP `FlowCollector` protocol so we can collect
/// Kotlin `StateFlow` emissions from Swift.
///
/// Usage:
/// ```swift
/// try await stateFlow.collect(
///     collector: SwiftFlowCollector { value in ... }
/// )
/// ```
final class SwiftFlowCollector: Kotlinx_coroutines_coreFlowCollector {

    private let onEmit: (Any?) -> Void

    init(_ onEmit: @escaping (Any?) -> Void) {
        self.onEmit = onEmit
    }

    // KMP exports `emit(value:)` as an async function
    // via the ObjC completion-handler bridge.
    func emit(value: Any?) async throws {
        onEmit(value)
    }
}
