//
//  GameSelectView.swift
//  PaviaPuzzle
//
//  Created by Adahan on 16/12/24.
//
 
// GameSelectView.swift
// PaviaPuzzle

import SwiftUI

struct GameSelectView: View {
    @State private var isLoading = false
    @State private var fetchedImage: UIImage? = nil
    @State private var showPuzzleView = false

    @State private var puzzleModel: PuzzleModel? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(spacing: 16) { }
                VStack(spacing: 16) {
                    Button(action: loadFunambolPuzzle) {
                        MainOptionView(
                            imageName: "puzzlepiece.fill",
                            imageColor: .white,
                            backgroundColor: .orange,
                            title: "Funambol Puzzle",
                            description: "The original prompt 3x3 grid puzzle."
                        )
                    }
                    .accessibilityIdentifier("funambolPuzzleButton") // Moved identifier to Button
                }
                .padding(.horizontal)
                VStack(spacing: 16) {
                    NavigationLink(destination: CustomGameView()) {
                        MainOptionView(
                            imageName: "gearshape.fill",
                            imageColor: .white,
                            backgroundColor: .gray,
                            title: "Custom Game",
                            description: "Why not add some twist in it eh?"
                        )
                    }
                    .accessibilityIdentifier("customGameButton") // Moved identifier to Button
                }
                .padding(.horizontal)

                Spacer()
            }
            .overlay(
                isLoading ? ProgressView("Loading...").scaleEffect(1.5).accessibilityIdentifier("LoadingIndicator") : nil
            )
            .navigationTitle("Pavia Puzzle")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(isPresented: $showPuzzleView) {
                if let puzzleModel = puzzleModel {
                    MainPuzzleView(puzzleModel: puzzleModel)
                }
            }
        }
    }

    private func loadFunambolPuzzle() {
        isLoading = true

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
                self.puzzleModel = PuzzleModel(puzzleImage: puzzleImage, gridOptions: 3, difficulty: .default)

                self.isLoading = false
                self.showPuzzleView = true
            }
        }.resume()
    }
}

struct GameSelectView_Previews: PreviewProvider {
    static var previews: some View {
        GameSelectView()
    }
}
