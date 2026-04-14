//
//  iosAppTests.swift
//  iosAppTests
//
//  Created by Akash K on 14/04/26.
//

import XCTest
import shared
@testable import iosApp

// MARK: - PokemonDisplayFormatter Tests

final class PokemonDisplayFormatterTests: XCTestCase {

    // MARK: formattedID (Int32)

    func test_formattedID_singleDigit_hasTwoLeadingZeros() {
        XCTAssertEqual(PokemonDisplayFormatter.formattedID(Int32(1)), "#001")
    }

    func test_formattedID_doubleDigit_hasOneLeadingZero() {
        XCTAssertEqual(PokemonDisplayFormatter.formattedID(Int32(25)), "#025")
    }

    func test_formattedID_tripleDigit_hasNoLeadingZero() {
        XCTAssertEqual(PokemonDisplayFormatter.formattedID(Int32(150)), "#150")
    }

    func test_formattedID_quadrupleDigit_exceedsThreeDigits() {
        XCTAssertEqual(PokemonDisplayFormatter.formattedID(Int32(1000)), "#1000")
    }

    func test_formattedID_zero_formatsCorrectly() {
        XCTAssertEqual(PokemonDisplayFormatter.formattedID(Int32(0)), "#000")
    }

    // MARK: formattedID (Int64)

    func test_formattedID_int64_singleDigit() {
        XCTAssertEqual(PokemonDisplayFormatter.formattedID(Int64(7)), "#007")
    }

    func test_formattedID_int64_tripleDigit() {
        XCTAssertEqual(PokemonDisplayFormatter.formattedID(Int64(251)), "#251")
    }

    // MARK: formattedName

    func test_formattedName_lowercase_isCapitalized() {
        XCTAssertEqual(PokemonDisplayFormatter.formattedName("pikachu"), "Pikachu")
    }

    func test_formattedName_alreadyCapitalized_remainsCorrect() {
        XCTAssertEqual(PokemonDisplayFormatter.formattedName("Bulbasaur"), "Bulbasaur")
    }

    func test_formattedName_allCaps_capitalizesThenLowercases() {
        // Swift's .capitalized lowercases all chars except the first of each word
        XCTAssertEqual(PokemonDisplayFormatter.formattedName("MEWTWO"), "Mewtwo")
    }

    func test_formattedName_emptyString_remainsEmpty() {
        XCTAssertEqual(PokemonDisplayFormatter.formattedName(""), "")
    }
}
