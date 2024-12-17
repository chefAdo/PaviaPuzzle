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
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var puzzleModel: PuzzleModel
    let difficulty: Difficulty
    @State internal var timeRemaining: Int = 0
    @State internal var timerActive: Bool = false
    @State internal var draggingTile: Tile? = nil
    @State internal var draggingOffset: CGSize = .zero
    @State internal var isTimeUp: Bool = false
    @State internal var isLoading: Bool = false
    @State internal var isTimeCritical: Bool = false

    enum ActiveAlert: Identifiable {
        case completion, timeUp

        var id: Int {
            switch self {
            case .completion: return 1
            case .timeUp: return 2
            }
        }
    }

    @State internal var activeAlert: ActiveAlert? = nil

    init(puzzleModel: PuzzleModel) {
        self.puzzleModel = puzzleModel
        self.difficulty = puzzleModel.difficulty
    }

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                let isPortrait = geometry.size.height >= geometry.size.width
                let gridDimension = min(geometry.size.width, geometry.size.height)

                ZStack {
                    // Grid View
                    GridView(
                        tiles: $puzzleModel.tiles,
                        gridSize: puzzleModel.gridOptions,
                        draggingTile: $draggingTile,
                        draggingOffset: $draggingOffset,
                        isMovable: !isTimeUp
                    ) {
                        handleTileSwap()
                    }
                    .frame(width: gridDimension, height: gridDimension)
                    .background(Color.clear)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    .onAppear {
                        startGame()
                        timeRemaining = difficulty.timeLimit ?? 0 // Ensure timer value is set
                    }

                    .onDisappear { pauseTimer() }

                    // Timer Label
                    if let timeLimit = difficulty.timeLimit {
                        VStack {
                            HStack {
                                Spacer()
                                Text("Time Left: \(timeRemaining)s")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(isTimeCritical ? Color.red : Color(UIColor.secondarySystemBackground))
                                            .animation(.easeInOut(duration: 0.5), value: isTimeCritical)
                                    )
                                    .accessibilityIdentifier("timerLabel") // Added identifier
                                    .onAppear {
                                        isTimeCritical = false
                                    }
                                    .padding(.top, isPortrait ? geometry.safeAreaInsets.top + 60 : geometry.safeAreaInsets.top + 20)
                                    .padding(.trailing, geometry.safeAreaInsets.trailing + 16)
                            }
                            Spacer()
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)

            if isLoading {
                Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2)
                    .accessibilityIdentifier("LoadingIndicator") // Added identifier
            }
        }
        .alert(item: $activeAlert) { alert in
            DispatchQueue.main.async {
                resetDraggingState()
            }
            switch alert {
            case .completion:
                return Alert(
                    title: Text("Congratulations!"),
                    message: Text("You completed the puzzle!"),
                    primaryButton: .default(Text("New Puzzle")) { loadFunambolPuzzle() },
                    secondaryButton: .destructive(Text("Quit")) { presentationMode.wrappedValue.dismiss() }
                )
            case .timeUp:
                return Alert(
                    title: Text("Time's Up!"),
                    message: Text("You ran out of time."),
                    primaryButton: .default(Text("New Puzzle")) { loadFunambolPuzzle() },
                    secondaryButton: .destructive(Text("Quit")) { presentationMode.wrappedValue.dismiss() }
                )
            }
        }
    }

    internal func handleTileSwap() {
        if puzzleModel.tiles.enumerated().allSatisfy({ $0.element.position == $0.offset }) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                activeAlert = .completion
            }
            pauseTimer()
        }
    }

    internal func startGame() {
        DispatchQueue.main.async {
            resetDraggingState()
        }
        if let timeLimit = difficulty.timeLimit {
            timeRemaining = timeLimit
            isTimeCritical = false
            startTimer()
        }
    }

    internal func resetDraggingState() {
        DispatchQueue.main.async {
            draggingTile = nil
            draggingOffset = .zero
        }
    }

    internal func loadFunambolPuzzle() {
        isLoading = true
        let url = URL(string: "https://picsum.photos/1024")!
        URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    self.puzzleModel.puzzleImage = image
                }
                isLoading = false
                startGame()
            }
        }.resume()
    }

    internal func startTimer() {
        timerActive = true
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            guard timerActive else { timer.invalidate(); return }
            if timeRemaining > 0 {
                timeRemaining -= 1
                if timeRemaining <= 5 {
                    isTimeCritical = true
                }
            } else {
                timer.invalidate()
                activeAlert = .timeUp
            }
        }
    }

    internal func pauseTimer() {
        timerActive = false
    }

    internal static func cropToSquare(image: UIImage) -> UIImage {
        let originalSize = image.size
        let squareSize = min(originalSize.width, originalSize.height)
        let xOffset = (originalSize.width - squareSize) / 2
        let yOffset = (originalSize.height - squareSize) / 2
        let cropRect = CGRect(x: xOffset, y: yOffset, width: squareSize, height: squareSize)
        guard let cgImage = image.cgImage?.cropping(to: cropRect) else { return image }
        return UIImage(cgImage: cgImage)
    }
}

struct MainPuzzleView_Previews: PreviewProvider {
    static var previews: some View {
        let puzzleImage = UIImage(named: "defaultImage") ?? UIImage()
        let puzzleModel = PuzzleModel(puzzleImage: puzzleImage, gridOptions: 3, difficulty: .default)
        MainPuzzleView(puzzleModel: puzzleModel)
    }
}
