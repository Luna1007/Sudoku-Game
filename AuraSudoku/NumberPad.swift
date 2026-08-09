import SwiftUI

struct NumberPad: View {
    let onNumberSelected: (Int) -> Void
    
    let numbers = [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9]
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(numbers, id: \.self) { row in
                HStack(spacing: 15) {
                    ForEach(row, id: \.self) { number in
                        NumberButton(number: number) {
                            onNumberSelected(number)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 10)
    }
}

struct NumberButton: View {
    let number: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("\(number)")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 65, height: 65)
                .background(
                    LinearGradient(
                        colors: [Color(hex: "#4A2B7A"), Color(hex: "#2D1B4E")],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .cornerRadius(33)
                .shadow(color: .purple.opacity(0.3), radius: 8)
                .overlay(
                    Circle()
                        .stroke(Color(hex: "#8A7CFF").opacity(0.5), lineWidth: 1)
                )
        }
    }
}

