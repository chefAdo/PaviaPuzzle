//
//  GridView.swift
//  PaviaPuzzle
//
//  Created by Adahan on 16/12/24.
//

import SwiftUI

struct GridView: View {
    @Binding var tiles: [Tile]
    let gridSize: Int
    @Binding var draggingTile: Tile?
    @Binding var draggingOffset: CGSize
    let onTileTap: () -> Void

    @State private var hoveredTileIndex: Int? = nil
    let spacing: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            let tileSize = (geometry.size.width - spacing * CGFloat(gridSize - 1)) / CGFloat(gridSize)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: spacing), count: gridSize), spacing: spacing) {
                ForEach(Array(tiles.indices), id: \.self) { index in
                    let tile = tiles[index]
                    let isCorrect = tile.position == index

                    ZStack {
                        if hoveredTileIndex == index {
                            Color.gray.opacity(0.3)
                                .cornerRadius(8)
                                .animation(.easeInOut, value: hoveredTileIndex)
                        }

                        Image(uiImage: tile.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                            .offset(tile == draggingTile ? draggingOffset : .zero)
                            .zIndex(tile == draggingTile ? 1 : 0)
                            .gesture(
                                isCorrect ? nil : DragGesture()
                                    .onChanged { value in
                                        if draggingTile == nil {
                                            draggingTile = tile
                                        }
                                        draggingOffset = value.translation

                                        // Calculate the center position of the dragged tile
                                        let currentRow = index / gridSize
                                        let currentCol = index % gridSize
                                        let centerX = CGFloat(currentCol) * (tileSize + spacing) + tileSize / 2 + draggingOffset.width
                                        let centerY = CGFloat(currentRow) * (tileSize + spacing) + tileSize / 2 + draggingOffset.height

                                        let targetRow = Int(centerY / (tileSize + spacing))
                                        let targetCol = Int(centerX / (tileSize + spacing))
                                        let targetIndex = targetRow * gridSize + targetCol

                                        if targetRow >= 0 && targetRow < gridSize && targetCol >= 0 && targetCol < gridSize {
                                            if targetIndex >= 0 && targetIndex < tiles.count && targetIndex != index {
                                                if tiles[targetIndex].position != targetIndex {
                                                    hoveredTileIndex = targetIndex
                                                } else {
                                                    hoveredTileIndex = nil
                                                }
                                            } else {
                                                hoveredTileIndex = nil
                                            }
                                        } else {
                                            hoveredTileIndex = nil
                                        }
                                    }
                                    .onEnded { _ in
                                        guard let draggingTile = draggingTile, let targetIndex = hoveredTileIndex else {
                                            withAnimation(.spring()) {
                                                draggingOffset = .zero
                                            }
                                            self.draggingTile = nil
                                            return
                                        }

                                        if let sourceIndex = tiles.firstIndex(where: { $0.id == draggingTile.id }) {
                                            withAnimation(.easeInOut) {
                                                tiles.swapAt(sourceIndex, targetIndex)
                                            }
                                        }

                                        self.draggingTile = nil
                                        draggingOffset = .zero
                                        hoveredTileIndex = nil

                                        onTileTap()
                                    }
                            )
                            .shadow(color: tile == draggingTile ? .black.opacity(0.3) : .clear, radius: 10)
                            .scaleEffect(tile == draggingTile ? 1.05 : 1.0)
                            .animation(.easeInOut(duration: 0.2), value: draggingTile)
                            .overlay(
                                RoundedRectangle(cornerRadius: 0)
                                    .stroke(Color.gray, lineWidth: 0)
                            )

                        if hoveredTileIndex == index {
                            Color.black.opacity(0.2)
                                .cornerRadius(8)
                                .transition(.opacity)
                        }
                    }
                    .background(
                        tile == draggingTile ? Color.clear : Color(UIColor.secondarySystemBackground)
                    )
                    .opacity(isCorrect ? 1.0 : (hoveredTileIndex == index ? 0.7 : 0.9))
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.width)
        }
    }
}
 
