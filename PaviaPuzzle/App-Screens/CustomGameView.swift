//
//  CustomGameView.swift
//  PaviaPuzzle
//
//  Created by Adahan on 16/12/24.
//
 
// CustomGameView.swift
// PaviaPuzzle

import SwiftUI

struct CustomGameView: View {
    @State private var isLoading = false
    @State private var fetchedImage: UIImage? = nil
    @State private var selectedGridOptions: Int = 3
    @State private var selectedDifficulty: Difficulty = .blitz
    @State private var showPuzzleView: Bool = false

    @State private var puzzleModel: PuzzleModel? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(spacing: 16) { }
                VStack(spacing: 16) {
                    Button(action: {
                        preparePuzzle(gridOptions: 3, difficulty: .blitz)
                    }) {
                        MainOptionView(
                            imageName: "bolt.fill",
                            imageColor: .yellow,
                            backgroundColor: .yellow,
                            title: "Blitz",
                            description: "3x3 grid with a fast-paced challenge."
                        )
                    }
                    .accessibilityIdentifier("blitzButton") // Moved identifier to Button

                    Button(action: {
                        preparePuzzle(gridOptions: 4, difficulty: .medium)
                    }) {
                        MainOptionView(
                            imageName: "timer",
                            imageColor: .orange,
                            backgroundColor: .orange,
                            title: "Medium",
                            description: "4x4 grid with a moderate challenge."
                        )
                    }
                    .accessibilityIdentifier("mediumButton") // Moved identifier to Button

                    Button(action: {
                        preparePuzzle(gridOptions: 5, difficulty: .hard)
                    }) {
                        MainOptionView(
                            imageName: "flame.fill",
                            imageColor: .red,
                            backgroundColor: .red,
                            title: "Extreme",
                            description: "5x5 grid for puzzle masters."
                        )
                    }
                    .accessibilityIdentifier("extremeButton") // Moved identifier to Button
                }
                .padding(.horizontal)

                Spacer()
            }
            .overlay(
                isLoading ? ProgressView("Loading...").scaleEffect(1.5).accessibilityIdentifier("LoadingIndicator") : nil
            )
            .navigationTitle("Custom Game")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(isPresented: $showPuzzleView) {
                if let puzzleModel = puzzleModel {
                    MainPuzzleView(puzzleModel: puzzleModel)
                }
            }
        }
    }

    private func preparePuzzle(gridOptions: Int, difficulty: Difficulty) {
        self.selectedGridOptions = gridOptions
        self.selectedDifficulty = difficulty
        self.isLoading = true

        // Download the image
        let url = URL(string: "https://picsum.photos/1024")!
        URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    self.fetchedImage = image
                } else {
                    self.fetchedImage = UIImage(named: "defaultImage")
                }

                let puzzleImage = self.fetchedImage ?? UIImage(named: "defaultImage") ?? UIImage()
                self.puzzleModel = PuzzleModel(puzzleImage: puzzleImage, gridOptions: gridOptions, difficulty: difficulty)

                self.isLoading = false
                self.showPuzzleView = true
            }
        }.resume()
    }
}

struct CustomGameView_Previews: PreviewProvider {
    static var previews: some View {
        CustomGameView()
    }
}
