import SwiftUI

struct SudokuGrid: View {
    let board: [[Int]]
    let fixedBoard: [[Int]]
    @Binding var selectedRow: Int?
    @Binding var selectedCol: Int?
    let isWrong: (Int, Int) -> Bool
    
    var body: some View {
        GeometryReader { geometry in
            let cellSize = (geometry.size.width) / 9
            
            VStack(spacing: 0) {
                ForEach(0..<9, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<9, id: \.self) { col in
                            SudokuCell(
                                value: board[row][col],
                                isFixed: fixedBoard[row][col] != 0,
                                isSelected: selectedRow == row && selectedCol == col,
                                isWrong: isWrong(row, col),
                                onTap: {
                                    selectedRow = row
                                    selectedCol = col
                                },
                                cellSize: cellSize,
                                row: row,
                                col: col
                            )
                        }
                    }
                    // Add bottom border for 3x3 rows
                    if (row + 1) % 3 == 0 && row != 8 {
                        Rectangle()
                            .fill(Color(hex: "#3A3650"))
                            .frame(height: 3)
                            .padding(.horizontal, 0)
                    }
                }
            }
            // Add right border for 3x3 columns
            .overlay(
                HStack(spacing: 0) {
                    ForEach(0..<8, id: \.self) { col in
                        Spacer()
                        if (col + 1) % 3 == 0 {
                            Rectangle()
                                .fill(Color(hex: "#3A3650"))
                                .frame(width: 3)
                        }
                    }
                    Spacer()
                }
            )
        }
        .aspectRatio(1, contentMode: .fit)
        .frame(maxWidth: .infinity)
    }
}

struct SudokuCell: View {
    let value: Int
    let isFixed: Bool
    let isSelected: Bool
    let isWrong: Bool
    let onTap: () -> Void
    let cellSize: CGFloat
    let row: Int
    let col: Int
    
    var body: some View {
        ZStack {
            // Background
            Rectangle()
                .fill(backgroundColor)
                .frame(width: cellSize, height: cellSize)
            
            // Number
            if value != 0 {
                Text("\(value)")
                    .font(.system(size: cellSize * 0.35, weight: .semibold))
                    .foregroundColor(textColor)
            }
        }
        .overlay(
            // Simple thin border for all cells
            Rectangle()
                .stroke(Color(hex: "#3A3650"), lineWidth: 0.5)
        )
        .onTapGesture {
            onTap()
        }
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return Color(hex: "#8A7CFF").opacity(0.3)
        } else if isWrong {
            return Color(hex: "#FF7C7C").opacity(0.2)
        } else {
            return Color(hex: "#2A1A4E")
        }
    }
    
    private var textColor: Color {
        if isWrong {
            return Color(hex: "#FF7C7C")
        } else if isFixed {
            return .white
        } else {
            return Color(hex: "#B87CFF")
        }
    }
}
