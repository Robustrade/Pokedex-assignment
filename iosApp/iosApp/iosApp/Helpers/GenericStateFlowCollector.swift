//
//  GenericStateFlowCollector.swift
//  iosApp
//
//  Created by Akash K on 12/04/26.
//

import shared

final class StateFlowCollector: Kotlinx_coroutines_coreFlowCollector {
    private let onEachValue: (Any?) -> Void

    init<State>(onEach: @escaping (State) -> Void) {
        self.onEachValue = { value in
            guard let state = value as? State else { return }
            onEach(state)
        }
    }

    func emit(value: Any?, completionHandler: @escaping (Error?) -> Void) {
        onEachValue(value)
        completionHandler(nil)
    }
}

extension Kotlinx_coroutines_coreFlow {
    func stream<Value>(of type: Value.Type = Value.self) -> AsyncStream<Value> {
        AsyncStream { continuation in
            let collector = StateFlowCollector { (value: Value) in
                continuation.yield(value)
            }

            collect(collector: collector) { _ in
                continuation.finish()
            }

            continuation.onTermination = { [collector] _ in
                withExtendedLifetime(collector) {}
            }
        }
    }
}
