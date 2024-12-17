//
//  PaviaPuzzleTests.swift
//  PaviaPuzzleTests
//
//  Created by Adahan on 17/12/24.
//

import XCTest
@testable import PaviaPuzzle

final class PaviaPuzzleTests: XCTestCase {

    func testPuzzleModelInitialization() {
        let testImage = UIImage(systemName: "square") ?? UIImage()
        let model = PuzzleModel(puzzleImage: testImage, gridOptions: 3, difficulty: .default)
        XCTAssertEqual(model.tiles.count, 9, "3x3 grid should have 9 tiles")
    }
    
    func testTileSetup() {
        let testImage = UIImage(systemName: "square") ?? UIImage()
        let model = PuzzleModel(puzzleImage: testImage, gridOptions: 3, difficulty: .default)
        XCTAssertFalse(model.tiles.isEmpty, "Tiles should be set up properly")
    }

    func testTileSwap() {
        let testImage = UIImage(systemName: "square") ?? UIImage()
        let model = PuzzleModel(puzzleImage: testImage, gridOptions: 3, difficulty: .default)
        let originalFirstTile = model.tiles[0]
        let originalSecondTile = model.tiles[1]
        
        model.swapTiles(at: 0, with: 1)
        
        XCTAssertEqual(model.tiles[0], originalSecondTile)
        XCTAssertEqual(model.tiles[1], originalFirstTile)
    }
    
    func testCompletionCheck() {
        let testImage = UIImage(systemName: "square") ?? UIImage()
        let model = PuzzleModel(puzzleImage: testImage, gridOptions: 3, difficulty: .default)
        
        model.tiles = model.tiles.sorted(by: { $0.position < $1.position })
        
        XCTAssertTrue(model.tiles.enumerated().allSatisfy { $0.element.position == $0.offset }, "Puzzle should be completed")
    }
}
