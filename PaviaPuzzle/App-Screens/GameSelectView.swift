//
//  GameSelectView.swift
//  PaviaPuzzle
//
//  Created by Adahan on 16/12/24.
//

import Foundation
import SwiftUI
struct GameSelectView: View {
    @State private var isLoading = false
    @State private var fetchedImage: UIImage? = nil
    @State private var showPuzzleView = false

    var body: some View {
           NavigationStack {
               VStack(spacing: 24) {
                   VStack(spacing: 16) {
                   }
                   VStack(spacing: 16) {
                       Button(action: loadFunambolPuzzle) {
                           MainOptionView(
                               imageName: "gamecontroller.fill",
                               imageColor: .blue,
                               backgroundColor: .blue,
                               title: "Funambol Puzzle",
                               description: "The original prompt-based 3x3 grid puzzle."
                           )
                       }
                   }
                   .padding(.horizontal)

                   Spacer()
               }
               .overlay(
                   isLoading ? ProgressView("Loading...").scaleEffect(1.5) : nil
               )
               .navigationTitle("Pavia Puzzle")
               .navigationBarTitleDisplayMode(.large)
               .navigationDestination(isPresented: $showPuzzleView) {
                   MainPuzzleView(
                       puzzleImage: fetchedImage ?? UIImage(named: "defaultImage") ?? UIImage(),
                       gridOptions: 3,
                       difficulty: .default
                   )
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
