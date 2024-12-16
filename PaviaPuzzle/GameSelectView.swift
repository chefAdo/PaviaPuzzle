//
//  GameSelectView.swift
//  PaviaPuzzle
//
//  Created by Adahan on 16/12/24.
//

import Foundation
import SwiftUI

struct GameSelectView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
             
                VStack(spacing: 24) {
                    
                }
                VStack(spacing: 16) {
                    NavigationLink(destination: FunambolPuzzleView()) {
                        MainOptionView(
                            imageName: "gamecontroller.fill",
                            imageColor: .blue,
                            backgroundColor: .blue,
                            title: "Funambol Puzzle",
                            description: "The original prompt-based 3x3 grid puzzle."
                        )
                    }

                    NavigationLink(destination: PaviaOptionsView()) {
                        MainOptionView(
                            imageName: "puzzlepiece.extension",
                            imageColor: .green,
                            backgroundColor: .orange,
                            title: "Pavia Puzzle",
                            description: "Explore the exciting new customized puzzle."
                        )
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .navigationTitle("Pavia Puzzle")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

 

struct FunambolPuzzleView: View {
    var body: some View {
        Text("Funambol Puzzle View")
            .font(.title)
    }
}

struct PaviaOptionsView: View {
    var body: some View {
        Text("Pavia Options View")
            .font(.title)
    }
}

struct GameSelectView_Previews: PreviewProvider {
    static var previews: some View {
        GameSelectView()
    }
}
