import SwiftUI
import Combine

class SudokuGame: ObservableObject {
    @Published var board: [[Int]] = Array(repeating: Array(repeating: 0, count: 9), count: 9)
    @Published var fixedBoard: [[Int]] = Array(repeating: Array(repeating: 0, count: 9), count: 9)
    @Published var elapsedSeconds = 0
    @Published var isGameWon = false
    @Published var wrongCells: Set<String> = []
    
    private var timer: Timer?
    private var solution: [[Int]] = Array(repeating: Array(repeating: 0, count: 9), count: 9)
    private var currentDifficulty: Difficulty = .easy
    
    init() {
        startTimer()
        generateNewPuzzle(difficulty: .easy)
    }
    
    func generateNewPuzzle(difficulty: Difficulty) {
        currentDifficulty = difficulty
        generateSolvedPuzzle()
        board = solution
        
        var cellsToRemove = getCellsToRemove(for: difficulty)
        while cellsToRemove > 0 {
            let row = Int.random(in: 0..<9)
            let col = Int.random(in: 0..<9)
            if board[row][col] != 0 {
                board[row][col] = 0
                cellsToRemove -= 1
            }
        }
        
        fixedBoard = board
        wrongCells.removeAll()
        isGameWon = false
        elapsedSeconds = 0
    }
    
    private func getCellsToRemove(for difficulty: Difficulty) -> Int {
        switch difficulty {
        case .easy: return 40
        case .medium: return 50
        case .hard: return 60
        case .expert: return 70
        case .random: return Int.random(in: 40...70)
        }
    }
    
    private func generateSolvedPuzzle() {
        var puzzle = Array(repeating: Array(repeating: 0, count: 9), count: 9)
        _ = solveSudoku(&puzzle)
        solution = puzzle
    }
    
    private func solveSudoku(_ board: inout [[Int]]) -> Bool {
        for row in 0..<9 {
            for col in 0..<9 {
                if board[row][col] == 0 {
                    for num in 1...9 {
                        if isValid(board: board, row: row, col: col, num: num) {
                            board[row][col] = num
                            if solveSudoku(&board) {
                                return true
                            }
                            board[row][col] = 0
                        }
                    }
                    return false
                }
            }
        }
        return true
    }
    
    private func isValid(board: [[Int]], row: Int, col: Int, num: Int) -> Bool {
        for x in 0..<9 {
            if board[row][x] == num { return false }
            if board[x][col] == num { return false }
        }
        
        let startRow = row - row % 3
        let startCol = col - col % 3
        for i in 0..<3 {
            for j in 0..<3 {
                if board[startRow + i][startCol + j] == num {
                    return false
                }
            }
        }
        return true
    }
    
    func setValue(row: Int, col: Int, value: Int) {
        guard fixedBoard[row][col] == 0 else { return }
        
        let cellKey = "\(row),\(col)"
        
        if value == 0 {
            board[row][col] = 0
            wrongCells.remove(cellKey)
        } else {
            board[row][col] = value
            if value != solution[row][col] {
                wrongCells.insert(cellKey)
            } else {
                wrongCells.remove(cellKey)
            }
        }
        checkWin()
    }
    
    func isFixed(row: Int, col: Int) -> Bool {
        return fixedBoard[row][col] != 0
    }
    
    func isWrong(row: Int, col: Int) -> Bool {
        return wrongCells.contains("\(row),\(col)")
    }
    
    func provideHint() {
        for row in 0..<9 {
            for col in 0..<9 {
                if fixedBoard[row][col] == 0 && (board[row][col] == 0 || board[row][col] != solution[row][col]) {
                    board[row][col] = solution[row][col]
                    wrongCells.remove("\(row),\(col)")
                    return
                }
            }
        }
    }
    
    func checkIfComplete() -> Bool {
        for row in 0..<9 {
            for col in 0..<9 {
                if board[row][col] != solution[row][col] {
                    return false
                }
            }
        }
        isGameWon = true
        stopTimer()
        return true
    }
    
    private func checkWin() {
        for row in 0..<9 {
            for col in 0..<9 {
                if board[row][col] != solution[row][col] {
                    return
                }
            }
        }
        isGameWon = true
        stopTimer()
    }
    
    func restart() {
        board = fixedBoard
        wrongCells.removeAll()
        isGameWon = false
        elapsedSeconds = 0
        startTimer()
    }
    
    // ✅ ONLY ONE startTimer() method
    func startTimer() {
        stopTimer() // Stop any existing timer first
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            DispatchQueue.main.async {
                if !self.isGameWon {
                    self.elapsedSeconds += 1
                }
            }
        }
    }
    
    // ✅ ONLY ONE stopTimer() method
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    var formattedTime: String {
        let minutes = elapsedSeconds / 60
        let seconds = elapsedSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
