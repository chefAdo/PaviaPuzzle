//
//  Tile.swift
//  PaviaPuzzle
//
//  Created by Adahan on 16/12/24.
//

import SwiftUI

struct Tile: Identifiable, Equatable {
    let id: UUID
    let image: UIImage
    var position: Int // Changed from 'let' to 'var'

    // Default initializer
    init(image: UIImage, position: Int) {
        self.id = UUID()
        self.image = image
        self.position = position
    }

    // Custom initializer for testing
    init(id: UUID, image: UIImage, position: Int) {
        self.id = id
        self.image = image
        self.position = position
    }

    static func == (lhs: Tile, rhs: Tile) -> Bool {
        return lhs.id == rhs.id
    }
}
