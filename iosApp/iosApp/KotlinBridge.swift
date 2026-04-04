import Foundation
import SwiftUI
import shared

// Bridges Kotlin `Flow` collectors to Swift.
final class FlowCollectorHelper: Kotlinx_coroutines_coreFlowCollector {
    private let onValue: (Any?) -> Void

    init(onValue: @escaping (Any?) -> Void) {
        self.onValue = onValue
    }

    func emit(value: Any?, completionHandler: @escaping (Error?) -> Void) {
        onValue(value)
        completionHandler(nil)
    }
}

enum PokemonList {
    static func pokemonArray(from value: Any?) -> [Pokemon] {
        guard let value else { return [] }
        if let direct = value as? [Pokemon] { return direct }
        if let arr = value as? [Any] {
            return arr.compactMap { $0 as? Pokemon }
        }
        if let ns = value as? NSArray {
            return (0..<ns.count).compactMap { ns.object(at: $0) as? Pokemon }
        }
        return []
    }
}

enum AppMotion {
    static let list = Animation.spring(response: 0.38, dampingFraction: 0.82)
    static let toggle = Animation.easeInOut(duration: 0.22)
}
