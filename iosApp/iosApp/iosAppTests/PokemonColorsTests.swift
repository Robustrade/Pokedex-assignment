import XCTest
import SwiftUI
@testable import iosApp

final class PokemonColorsTests: XCTestCase {
    
    func testTypeColorReturnsCorrectColorForKnownTypes() {
        let fireColor = PokemonColors.typeColor(for: "fire")
        let waterColor = PokemonColors.typeColor(for: "water")
        let grassColor = PokemonColors.typeColor(for: "grass")
        
        XCTAssertNotEqual(fireColor, waterColor)
        XCTAssertNotEqual(waterColor, grassColor)
        XCTAssertNotEqual(fireColor, grassColor)
    }
    
    func testTypeColorCaseInsensitive() {
        let lowerCase = PokemonColors.typeColor(for: "fire")
        let upperCase = PokemonColors.typeColor(for: "FIRE")
        let mixedCase = PokemonColors.typeColor(for: "Fire")
        
        XCTAssertEqual(lowerCase, upperCase)
        XCTAssertEqual(lowerCase, mixedCase)
    }
    
    func testTypeColorReturnsGrayForUnknownType() {
        let unknownColor = PokemonColors.typeColor(for: "unknown_type")
        let expectedGray = Color.gray
        
        XCTAssertEqual(unknownColor, expectedGray)
    }
    
    func testStatColorReturnsCorrectColorForKnownStats() {
        let hpColor = PokemonColors.statColor(for: "hp")
        let attackColor = PokemonColors.statColor(for: "attack")
        let defenseColor = PokemonColors.statColor(for: "defense")
        
        XCTAssertNotEqual(hpColor, attackColor)
        XCTAssertNotEqual(attackColor, defenseColor)
    }
    
    func testColorHexInitializer() {
        let redColor = Color(hex: "FF0000")
        let greenColor = Color(hex: "00FF00")
        let blueColor = Color(hex: "0000FF")
        
        XCTAssertNotEqual(redColor, greenColor)
        XCTAssertNotEqual(greenColor, blueColor)
        XCTAssertNotEqual(redColor, blueColor)
    }
    
    func testColorHexInitializerWithShortFormat() {
        let shortHex = Color(hex: "F00")
        XCTAssertNotNil(shortHex)
    }
    
    func testColorHexInitializerWithAlpha() {
        let colorWithAlpha = Color(hex: "80FF0000")
        XCTAssertNotNil(colorWithAlpha)
    }
}
