//
//  PokemonDisplayFormatter.swift
//  iosApp
//
//  Created by Akash K on 13/04/26.
//

import Foundation

enum PokemonDisplayFormatter {
    static func formattedID(_ id: Int32) -> String {
        String(format: "#%03d", Int(id))
    }

    static func formattedID(_ id: Int64) -> String {
        String(format: "#%03d", Int(id))
    }

    static func formattedName(_ name: String) -> String {
        name.capitalized
    }
}
