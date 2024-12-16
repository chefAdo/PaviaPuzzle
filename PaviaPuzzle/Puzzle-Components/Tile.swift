//
//  Tile.swift
//  PaviaPuzzle
//
//  Created by Adahan on 16/12/24.
//

import SwiftUI

struct Tile: Identifiable, Equatable {
    let id = UUID()
    let image: UIImage
    let position: Int 

    static func == (lhs: Tile, rhs: Tile) -> Bool {
        lhs.id == rhs.id
    }
}
 
