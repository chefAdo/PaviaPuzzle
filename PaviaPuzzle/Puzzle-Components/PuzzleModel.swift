//
//  PuzzleModel.swift
//  PaviaPuzzle
//
//  Created by Adahan on 17/12/24.
//


import SwiftUI

class PuzzleModel: ObservableObject {
    @Published var tiles: [Tile] = []
    let gridOptions: Int
    var puzzleImage: UIImage {
        didSet {
            setupTiles()
        }
    }
    let difficulty: Difficulty

    init(puzzleImage: UIImage, gridOptions: Int, difficulty: Difficulty) {
        self.puzzleImage = MainPuzzleView.cropToSquare(image: puzzleImage)
        self.gridOptions = gridOptions
        self.difficulty = difficulty
        setupTiles()
    }

    func setupTiles() {
        let tileSize = puzzleImage.size.width / CGFloat(gridOptions)
        var allTiles: [Tile] = []

        for row in 0..<gridOptions {
            for col in 0..<gridOptions {
                let x = CGFloat(col) * tileSize
                let y = CGFloat(row) * tileSize
                let tileRect = CGRect(x: x, y: y, width: tileSize, height: tileSize)
                if let tileImage = puzzleImage.cgImage?.cropping(to: tileRect) {
                    let uiImage = UIImage(cgImage: tileImage)
                    allTiles.append(Tile(image: uiImage, position: row * gridOptions + col))
                }
            }
        }

        var shuffledTiles = allTiles
        repeat {
            shuffledTiles.shuffle()
        } while shuffledTiles == allTiles

        self.tiles = shuffledTiles

    }

    func swapTiles(at sourceIndex: Int, with targetIndex: Int) {
        guard sourceIndex != targetIndex,
              sourceIndex >= 0, sourceIndex < tiles.count,
              targetIndex >= 0, targetIndex < tiles.count else { return }

        tiles.swapAt(sourceIndex, targetIndex)

        // Check if the puzzle is solved
        if tiles.enumerated().allSatisfy({ $0.element.position == $0.offset }) {
            // Handle puzzle completion (e.g., notify observers)
            // This can be implemented using Combine publishers or delegate patterns
        }
    }
}
