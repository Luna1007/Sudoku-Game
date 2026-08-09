import SwiftUI

struct WinView: View {
    let timeElapsed: Int
    let onPlayAgain: () -> Void
    let onHome: () -> Void
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        ZStack {
            // Dynamic background based on dark mode
            if isDarkMode {
                LinearGradient(
                    colors: [Color(hex: "#1A0B2E"), Color(hex: "#4A2B7A"), Color(hex: "#8A7CFF")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            } else {
                LinearGradient(
                    colors: [Color(hex: "#F0E6FF"), Color(hex: "#E8D8FF"), Color(hex: "#FFFFFF")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            }
            
            VStack(spacing: 30) {
                Spacer()
                
                // Animated sparkle
                Image(systemName: "sparkles")
                    .font(.system(size: 70))
                    .foregroundColor(isDarkMode ? .yellow : Color(hex: "#FFD47C"))
                    .shadow(color: (isDarkMode ? .yellow : Color(hex: "#FFD47C")).opacity(0.5), radius: 20)
                
                // Victory Text
                VStack(spacing: 10) {
                    Text("VICTORY!")
                        .font(.system(size: 50, weight: .black, design: .rounded))
                        .foregroundColor(isDarkMode ? .white : Color(hex: "#1A0B2E"))
                    
                    Text("Congratulations!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#B87CFF"))
                }
                
                // Time Card
                VStack(spacing: 12) {
                    Text("Completion Time")
                        .font(.headline)
                        .foregroundColor(isDarkMode ? .white.opacity(0.7) : Color(hex: "#1A0B2E").opacity(0.7))
                    
                    Text(formatTime(timeElapsed))
                        .font(.system(size: 55, weight: .bold, design: .monospaced))
                        .foregroundColor(Color(hex: "#B87CFF"))
                }
                .frame(maxWidth: .infinity)
                .padding(30)
                .background(
                    isDarkMode ?
                    Color.white.opacity(0.1) :
                    Color.white.opacity(0.8)
                )
                .cornerRadius(30)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color(hex: "#8A7CFF").opacity(0.5), lineWidth: 2)
                )
                .padding(.horizontal, 40)
                .shadow(color: .purple.opacity(0.2), radius: 10)
                
                Spacer()
                
                // Play Again Button
                Button(action: onPlayAgain) {
                    HStack {
                        Image(systemName: "play.circle.fill")
                            .font(.title3)
                        Text("PLAY AGAIN")
                            .font(.title3.bold())
                    }
                    .frame(width: 250, height: 60)
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "#8A7CFF"), Color(hex: "#B87CFF")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(30)
                    .shadow(color: Color(hex: "#8A7CFF").opacity(0.4), radius: 15)
                }
                
                // Menu Button
                Button(action: onHome) {
                    HStack {
                        Image(systemName: "house.fill")
                            .font(.title3)
                        Text("MENU")
                            .font(.title3.bold())
                    }
                    .frame(width: 200, height: 50)
                    .background(
                        isDarkMode ?
                        Color.white.opacity(0.15) :
                        Color.purple.opacity(0.1)
                    )
                    .foregroundColor(isDarkMode ? .white : Color(hex: "#1A0B2E"))
                    .cornerRadius(25)
                }
                
                Spacer()
                    .frame(height: 30)
            }
            .padding()
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
}
