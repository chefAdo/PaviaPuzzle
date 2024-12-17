//
//  MainOptionView.swift
//  PaviaPuzzle
//
//  Created by Adahan on 16/12/24.
//
 
import SwiftUI

struct MainOptionView: View {
    let imageName: String
    let imageColor: Color
    let backgroundColor: Color
    let title: String
    let description: String
    var accessibilityIdentifier: String? = nil // Added parameter

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(backgroundColor)
                    .frame(width: 80, height: 80)

                Image(systemName: imageName)
                    .font(.system(size: 25, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.leading, 10)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.leading)
            }
            .padding(.vertical, 10)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
                .padding(.trailing, 10)
        }
        .frame(height: 100)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.5), lineWidth: 2)
        )
        .accessibilityElement()
        .accessibilityIdentifier(accessibilityIdentifier ?? title) // Assigning identifier
    }
}

#Preview {
    MainOptionView(
        imageName: "gamecontroller.fill",
        imageColor: .blue,
        backgroundColor: .blue,
        title: "Funambol Puzzle",
        description: "The original prompt-based 3x3 grid puzzle.",
        accessibilityIdentifier: "funambolPuzzleButton" // Example identifier
    )
}
