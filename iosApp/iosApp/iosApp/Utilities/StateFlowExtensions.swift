import Foundation
import shared

extension Kotlinx_coroutines_coreStateFlow {
    func stream<T>() -> AsyncStream<T> {
        AsyncStream { continuation in
            let collector = StateFlowCollector { value in
                if let typedValue = value as? T {
                    continuation.yield(typedValue)
                }
            }
            
            Task {
                do {
                    try await self.collect(collector: collector)
                } catch {
                    continuation.finish()
                }
            }
            
            continuation.onTermination = { _ in }
        }
    }
}

private class StateFlowCollector: Kotlinx_coroutines_coreFlowCollector {
    private let onEmit: (Any?) -> Void
    
    init(onEmit: @escaping (Any?) -> Void) {
        self.onEmit = onEmit
    }
    
    func emit(value: Any?, completionHandler: @escaping (Error?) -> Void) {
        onEmit(value)
        completionHandler(nil)
    }
}
