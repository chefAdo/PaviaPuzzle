//
//  MainPuzzleView.swift
//  PaviaPuzzle
//
//  Created by Adahan on 16/12/24.
//

import SwiftUI
import UIKit
import AVFoundation

struct MainPuzzleView: View {

    let puzzleImage: UIImage
    let gridOptions: Int
    let difficulty: Difficulty

    @State private var timeRemaining: Int = 0
    @State private var timerActive: Bool = false
    @State private var tiles: [Tile] = []
    @State private var completed: Bool = false
    @State private var draggingTile: Tile? = nil
    @State private var draggingOffset: CGSize = .zero
    @State private var gridSize: CGSize = .zero
    @State private var isTimeUp: Bool = false
    @State private var showTimeUpAlertState: Bool = false
    
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

    init(puzzleImage: UIImage = UIImage(named: "defaultImage") ?? UIImage(), gridOptions: Int = 3, difficulty: Difficulty = .default) {
        self.puzzleImage = MainPuzzleView.cropToSquare(image: puzzleImage)
        self.gridOptions = gridOptions
        self.difficulty = difficulty
    }

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                let isPortrait = geometry.size.height >= geometry.size.width
                let gridDimension = min(geometry.size.width, geometry.size.height)

                VStack {
                    if isPortrait, let _ = difficulty.timeLimit {
                        Text("Time Remaining: \(timeRemaining)")
                            .font(.headline)
                            .padding(.top)
                    }


                    Spacer()

                    GridView(
                        tiles: $tiles,
                        gridSize: gridOptions,
                        draggingTile: $draggingTile,
                        draggingOffset: $draggingOffset,
                        isMovable: !isTimeUp
                    ) {
                        handleTileSwap()
                    }
                    .frame(width: gridDimension, height: gridDimension)
                    .background(Color(UIColor.secondarySystemBackground).cornerRadius(12))
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)  

                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                .onAppear {
                    startGame()
                }
                .onDisappear {
                    pauseTimer()
                }
                .navigationTitle(isPortrait ? "Puzzle" : "")
                .navigationBarTitleDisplayMode(.large)
                .alert(isPresented: $completed) {
                    Alert(title: Text("Congratulations!"), message: Text("You completed the puzzle!"), dismissButton: .default(Text("OK")))
                }
                .alert(isPresented: $showTimeUpAlertState) {
                    Alert(
                        title: Text("Time's Up!"),
                        message: Text("You ran out of time."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
    }

    private func handleTileSwap() {
        if tiles.allSatisfy({ $0.position == tiles.firstIndex(of: $0) }) {
            completed = true
            pauseTimer()
        }
    }

    private func startGame() {
        setupTiles()
        if let timeLimit = difficulty.timeLimit {
            timeRemaining = timeLimit
            startTimer()
        }
    }

    private func setupTiles() {
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
        } while shuffledTiles.enumerated().contains { $0.element.position == $0.offset }

        tiles = shuffledTiles
    }

    private static func cropToSquare(image: UIImage) -> UIImage {
        let originalSize = image.size
        let squareSize = min(originalSize.width, originalSize.height)
        let xOffset = (originalSize.width - squareSize) / 2
        let yOffset = (originalSize.height - squareSize) / 2
        let cropRect = CGRect(x: xOffset, y: yOffset, width: squareSize, height: squareSize)

        guard let cgImage = image.cgImage?.cropping(to: cropRect) else { return image }
        return UIImage(cgImage: cgImage)
    }

    private func startTimer() {
        timerActive = true
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            guard timerActive else { timer.invalidate(); return }

            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer.invalidate()
                showTimeUpAlert()
            }
        }
    }

    private func pauseTimer() {
        timerActive = false
    }

    private func showTimeUpAlert() {
        isTimeUp = true
        showTimeUpAlertState = true
    }
}

struct MainPuzzleView_Previews: PreviewProvider {
    static var previews: some View {
        MainPuzzleView()
    }
}
