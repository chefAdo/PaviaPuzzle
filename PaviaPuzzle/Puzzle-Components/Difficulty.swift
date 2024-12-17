//
//  Difficulty.swift
//  PaviaPuzzle
//
//  Created by Adahan on 17/12/24.
//

import SwiftUI

enum Difficulty {
    case `default`, medium, hard, blitz

    var timeLimit: Int? {
        switch self {
        case .medium: return 45
        case .hard: return 100
        case .blitz: return 15
        default: return nil
        }
    }
}
