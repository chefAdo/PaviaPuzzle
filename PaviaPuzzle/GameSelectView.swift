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
            VStack(spacing: 40) {
                // Top Icon and Title
                VStack(spacing: 16) {
                    Image(systemName: "puzzlepiece.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.blue)

                    Text("Pavia Puzzle")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }

                Spacer()

                // Options
                VStack(spacing: 24) {
                    NavigationLink(destination: FunambolPuzzleView()) {
                        GameOptionView(
                            imageName: "gamecontroller.fill",
                            title: "Funambol Puzzle",
                            description: "The original prompt-based 3x3 grid puzzle."
                        )
                    }

                    NavigationLink(destination: PaviaOptionsView()) {
                        GameOptionView(
                            imageName: "puzzlepiece.extension",
                            title: "Pavia Puzzle",
                            description: "Explore the exciting new customized puzzle."
                        )
                    }
                }

                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}

struct GameOptionView: View {
    let imageName: String
    let title: String
    let description: String

    var body: some View {
        HStack {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.blue)
                .padding(.trailing, 16)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

// Placeholder Views for Navigation Links
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
