//
//  ContentView.swift
//  2048-ray
//
//  Created by Rayo Belihomji on 1/6/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var gameManager = GameManager()

    var body: some View {
        VStack {
            Text("2048")
                .font(.largeTitle)
                .bold()
                .padding()

            Text("Score: \(gameManager.score)")
                .font(.headline)
                .padding()
            
            // Reset button
                       Button(action: {
                           gameManager.resetGame() // Calls the reset game function
                       }) {
                           Text("Reset Game")
                               .font(.headline)
                               .padding()
                               .background(Color.blue)
                               .foregroundColor(.white)
                               .cornerRadius(10)
                       }
                       .padding()

            GridView(grid: gameManager.grid)

            Spacer()

            if gameManager.gameOver {
                Text("Game Over!")
                    .font(.headline)
                    .foregroundColor(.red)
                    .padding()
                Button("Restart") {
                    gameManager.startGame()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .gesture(
            DragGesture()
                .onEnded { value in
                    let xDiff = value.translation.width
                    let yDiff = value.translation.height

                    if abs(xDiff) > abs(yDiff) {
                        if xDiff > 0 {
                            gameManager.move(direction: .right)
                        } else {
                            gameManager.move(direction: .left)
                        }
                    } else {
                        if yDiff > 0 {
                            gameManager.move(direction: .down)
                        } else {
                            gameManager.move(direction: .up)
                        }
                    }
                }
        )
    }
}

struct GridView: View {
    let grid: [[Int]]

    var body: some View {
        VStack(spacing: 10) {
            ForEach(0..<4, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(0..<4, id: \.self) { col in
                        TileView(value: grid[row][col])
                    }
                }
            }
        }
        .padding()
    }
}

struct TileView: View {
    let value: Int

    var body: some View {
        ZStack {
            Rectangle()
                .fill(color(for: value))
                .cornerRadius(8)

            if value > 0 {
                Text("\(value)")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
            }
        }
        .frame(width: 80, height: 80)
    }

    func color(for value: Int) -> Color {
        switch value {
        case 2: return Color.yellow
        case 4: return Color.orange
        case 8: return Color.red
        case 16: return Color.purple
        case 32: return Color.blue
        case 64: return Color.green
        case 128...: return Color.brown
        default: return Color.gray
        }
    }
}
