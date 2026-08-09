import SwiftUI

struct GameView: View {
    let difficulty: Difficulty
    @AppStorage("isDarkMode") private var isDarkMode = false
    @StateObject private var game = SudokuGame()
    @State private var selectedRow: Int?
    @State private var selectedCol: Int?
    @State private var showWinView = false
    @State private var showPauseMenu = false
    @State private var gridSize: CGFloat = 0
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Dynamic background based on dark mode
                (isDarkMode ? Color(hex: "#1A0B2E") : Color(hex: "#F0E6FF"))
                    .ignoresSafeArea()
                
                VStack(spacing: 15) {
                    // Top Bar
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(isDarkMode ? .white : Color(hex: "#1A0B2E"))
                                .frame(width: 44, height: 44)
                                .background(isDarkMode ? Color.white.opacity(0.1) : Color.purple.opacity(0.1))
                                .cornerRadius(12)
                        }
                        
                        Spacer()
                        
                        // Timer
                        HStack(spacing: 8) {
                            Image(systemName: "clock.fill")
                                .foregroundColor(Color(hex: "#B87CFF"))
                            Text(game.formattedTime)
                                .font(.title2.monospacedDigit())
                                .foregroundColor(isDarkMode ? .white : Color(hex: "#1A0B2E"))
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(isDarkMode ? Color.white.opacity(0.1) : Color.white.opacity(0.8))
                        .cornerRadius(25)
                        
                        Spacer()
                        
                        // Pause Button - FIXED to stop timer
                        Button(action: {
                            game.stopTimer()  // This stops the timer
                            showPauseMenu = true
                        }) {
                            Image(systemName: "pause.circle.fill")
                                .font(.title2)
                                .foregroundColor(isDarkMode ? .white : Color(hex: "#1A0B2E"))
                                .frame(width: 44, height: 44)
                                .background(isDarkMode ? Color.white.opacity(0.1) : Color.purple.opacity(0.1))
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Sudoku Grid
                    SudokuGrid(
                        board: game.board,
                        fixedBoard: game.fixedBoard,
                        selectedRow: $selectedRow,
                        selectedCol: $selectedCol,
                        isWrong: { row, col in
                            game.isWrong(row: row, col: col)
                        }
                    )
                    .frame(
                        width: max(geometry.size.width - 40, 280),
                        height: max(geometry.size.width - 40, 280)
                    )
                    .background(isDarkMode ? Color(hex: "#2A1A4E") : Color(hex: "#FFFFFF"))
                    .cornerRadius(20)
                    .shadow(color: .purple.opacity(0.3), radius: 15)
                    
                    // Number Pad
                    NumberPad(onNumberSelected: { number in
                        if let row = selectedRow, let col = selectedCol {
                            game.setValue(row: row, col: col, value: number)
                        }
                    })
                    .padding(.horizontal)
                    
                    // Bottom Buttons
                    HStack(spacing: 12) {
                        ActionButton(
                            icon: "delete.left.fill",
                            title: "Erase",
                            color: Color(hex: "#FF7C7C"),
                            isDarkMode: isDarkMode,
                            action: {
                                if let row = selectedRow, let col = selectedCol {
                                    game.setValue(row: row, col: col, value: 0)
                                }
                            }
                        )
                        
                        ActionButton(
                            icon: "lightbulb.fill",
                            title: "Hint",
                            color: Color(hex: "#FFD47C"),
                            isDarkMode: isDarkMode,
                            action: {
                                game.provideHint()
                            }
                        )
                        
                        ActionButton(
                            icon: "arrow.clockwise",
                            title: "Reset",
                            color: Color(hex: "#8A7CFF"),
                            isDarkMode: isDarkMode,
                            action: {
                                game.restart()
                                selectedRow = nil
                                selectedCol = nil
                            }
                        )
                        
                        ActionButton(
                            icon: "checkmark.circle.fill",
                            title: "Check",
                            color: Color(hex: "#7CFF9E"),
                            isDarkMode: isDarkMode,
                            action: {
                                if game.checkIfComplete() {
                                    showWinView = true
                                }
                            }
                        )
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                }
                .padding(.vertical)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            game.generateNewPuzzle(difficulty: difficulty)
        }
        .onReceive(game.$isGameWon) { won in
            if won {
                showWinView = true
            }
        }
        .fullScreenCover(isPresented: $showWinView) {
            WinView(
                timeElapsed: game.elapsedSeconds,
                onPlayAgain: {
                    showWinView = false
                    game.restart()
                    selectedRow = nil
                    selectedCol = nil
                },
                onHome: {
                    showWinView = false
                    dismiss()
                }
            )
        }
        .sheet(isPresented: $showPauseMenu) {
            VStack(spacing: 20) {
                Text("Paused")
                    .font(.largeTitle.bold())
                    .foregroundColor(Color(hex: "#8A7CFF"))
                    .padding(.top, 30)
                
                Text("Your game has been saved. Take a break!")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Divider()
                    .padding(.horizontal)
                
                // Resume Button - FIXED to restart timer
                Button(action: {
                    game.startTimer()  // This restarts the timer
                    showPauseMenu = false
                }) {
                    Text("Resume")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#8A7CFF"))
                        .cornerRadius(15)
                        .padding(.horizontal)
                }
                
                Button(action: {
                    game.restart()
                    selectedRow = nil
                    selectedCol = nil
                    showPauseMenu = false
                }) {
                    Text("Restart")
                        .font(.title3.bold())
                        .foregroundColor(Color(hex: "#FF7C7C"))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(15)
                        .padding(.horizontal)
                }
                
                Button(action: {
                    showPauseMenu = false
                    dismiss()
                }) {
                    Text("Main Menu")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(15)
                        .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .background(isDarkMode ? Color(hex: "#2A1A4E") : Color(hex: "#FFFFFF"))
            .presentationDetents([.height(350)])
            .presentationDragIndicator(.visible)
        }
    }
}

struct ActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let isDarkMode: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.caption2)
            }
            .frame(width: 65, height: 60)
            .background(isDarkMode ? Color.white.opacity(0.1) : Color.purple.opacity(0.1))
            .foregroundColor(color)
            .cornerRadius(12)
        }
    }
}
