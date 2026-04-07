import Foundation

/// Shared presentation formatters used by ViewModels and Components.
/// Keeps formatting logic out of Views.
enum PokemonFormatter {

    static func formattedId(_ id: Int32) -> String {
        String(format: "#%03d", id)
    }

    static func displayName(_ name: String) -> String {
        name.capitalized
    }
}
