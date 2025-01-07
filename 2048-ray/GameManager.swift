//
//  GameManager.swift
//  2048-ray
//
//  Created by Rayo Belihomji on 1/6/25.
//

import Foundation

class GameManager: ObservableObject {
    @Published var grid: [[Int]] = Array(repeating: Array(repeating: 0, count: 4), count: 4)
    @Published var score = 0
    @Published var gameOver = false

    init() {
        startGame()
    }
    
    // Method to reset the game
    func resetGame() {
        startGame() // Simply restart the game logic
    }
        
    // Helper function to create an empty grid
    private static func createEmptyGrid() -> [[Int]] {
        return Array(repeating: Array(repeating: 0, count: 4), count: 4)
    }
    

    // Start the game
    func startGame() {
        score = 0
        gameOver = false
        grid = Array(repeating: Array(repeating: 0, count: 4), count: 4)
        addRandomTile()
        addRandomTile()
    }

    // Add a random tile (2 or 4)
    private func addRandomTile() {
        let emptyCells = grid.enumerated().flatMap { rowIndex, row in
            row.enumerated().compactMap { colIndex, value in
                value == 0 ? (rowIndex, colIndex) : nil
            }
        }

        guard let randomCell = emptyCells.randomElement() else { return }
        grid[randomCell.0][randomCell.1] = Int.random(in: 0..<10) < 9 ? 2 : 4
    }

    // Handle swipe directions
    func move(direction: Direction) {
        let originalGrid = grid
        switch direction {
        case .up: moveUp()
        case .down: moveDown()
        case .left: moveLeft()
        case .right: moveRight()
        }
        


        if grid != originalGrid {
            addRandomTile()
            checkGameOver()
        }
    }

    private func moveLeft() {
        for rowIndex in 0..<4 {
            grid[rowIndex] = merge(row: grid[rowIndex])
        }
    }

    private func moveRight() {
        for rowIndex in 0..<4 {
            grid[rowIndex] = merge(row: grid[rowIndex].reversed()).reversed()
        }
    }

    private func moveUp() {
        for colIndex in 0..<4 {
            let column = (0..<4).map { grid[$0][colIndex] }
            let mergedColumn = merge(row: column)
            for rowIndex in 0..<4 {
                grid[rowIndex][colIndex] = mergedColumn[rowIndex]
            }
        }
    }

    private func moveDown() {
        for colIndex in 0..<4 {
            let reversedColumn = (0..<4).map { grid[$0][colIndex] }.reversed() // ReversedCollection
            let mergedColumn = merge(row: Array(reversedColumn)) // Convert to Array before passing
            let finalColumn = Array(mergedColumn.reversed()) // Reverse back to original order
            for rowIndex in 0..<4 {
                grid[rowIndex][colIndex] = finalColumn[rowIndex]
            }
        }
    }

    private func merge(row: [Int]) -> [Int] {
        var filteredRow = row.filter { $0 != 0 }
        var mergedRow: [Int] = []
        var skip = false

        for i in 0..<filteredRow.count {
            if skip {
                skip = false
                continue
            }

            if i < filteredRow.count - 1 && filteredRow[i] == filteredRow[i + 1] {
                mergedRow.append(filteredRow[i] * 2)
                score += filteredRow[i] * 2
                skip = true
            } else {
                mergedRow.append(filteredRow[i])
            }
        }

        while mergedRow.count < 4 {
            mergedRow.append(0)
        }

        return mergedRow
    }

    private func checkGameOver() {
        if !grid.flatMap({ $0 }).contains(0) && !canMerge() {
            gameOver = true
        }
    }

    private func canMerge() -> Bool {
        for row in 0..<4 {
            for col in 0..<4 {
                let value = grid[row][col]
                if row < 3 && grid[row + 1][col] == value { return true }
                if col < 3 && grid[row][col + 1] == value { return true }
            }
        }
        return false
    }

    enum Direction {
        case up, down, left, right
    }
}
