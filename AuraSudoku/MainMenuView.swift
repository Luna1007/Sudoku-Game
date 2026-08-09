import SwiftUI

struct MainMenuView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var selectedDifficulty: Difficulty = .easy
    @State private var showGame = false
    @State private var showSettings = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Dynamic background based on dark mode
                if isDarkMode {
                    LinearGradient(
                        colors: [Color(hex: "#1A0B2E"), Color(hex: "#2D1B4E"), Color(hex: "#4A2B7A")],
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
                
                VStack(spacing: 25) {
                    Spacer()
                    
                    // MARK: - Stylish Logo Section
                    VStack(spacing: 15) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: "#8A7CFF").opacity(0.3), Color(hex: "#B87CFF").opacity(0.1)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(width: 180, height: 180)
                                .blur(radius: 20)
                            
                            VStack(spacing: 10) {
                                Text("AURA")
                                    .font(.system(size: 48, weight: .black, design: .rounded))
                                    .foregroundColor(isDarkMode ? .white : Color(hex: "#1A0B2E"))
                                    .shadow(color: Color(hex: "#B87CFF").opacity(0.5), radius: 5)
                                
                                HStack(spacing: 0) {
                                    ForEach(Array("SUDOKU".enumerated()), id: \.offset) { index, letter in
                                        Text(String(letter))
                                            .font(.system(size: 18, weight: .bold, design: .rounded))
                                            .foregroundColor(Color(hex: "#B87CFF"))
                                            .shadow(color: Color(hex: "#B87CFF").opacity(0.4), radius: 3)
                                            .offset(y: index % 2 == 0 ? -2 : 2)
                                    }
                                }
                                
                                Capsule()
                                    .fill(LinearGradient(
                                        colors: [Color(hex: "#8A7CFF"), Color(hex: "#B87CFF")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ))
                                    .frame(width: 80, height: 3)
                                    .padding(.top, 5)
                            }
                        }
                    }
                    .padding(.top, 40)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    // MARK: - Difficulty Selection - FIXED: All in one line
                    VStack(alignment: .leading, spacing: 15) {
                        Text("CHOOSE DIFFICULTY")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "#B87CFF"))
                            .tracking(2)
                            .padding(.leading, 10)
                        
                        // Allow horizontal scrolling if needed, or use smaller text
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(Difficulty.allCases, id: \.self) { difficulty in
                                    DifficultyButton(
                                        title: difficulty.rawValue,
                                        isSelected: selectedDifficulty == difficulty,
                                        color: difficulty.color
                                    ) {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            selectedDifficulty = difficulty
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 5)
                        }
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Play Button
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            showGame = true
                        }
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "play.circle.fill")
                                .font(.title2)
                            Text("START GAME")
                                .font(.title2.bold())
                            Image(systemName: "arrow.right")
                                .font(.title3)
                        }
                        .frame(width: 260, height: 60)
                        .background(
                            LinearGradient(
                                colors: [Color(hex: "#8A7CFF"), Color(hex: "#B87CFF")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(30)
                        .shadow(color: Color(hex: "#8A7CFF").opacity(0.5), radius: 15, x: 0, y: 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                    }
                    .padding(.top, 10)
                    
                    // MARK: - Settings Button
                    Button(action: {
                        withAnimation(.spring()) {
                            showSettings = true
                        }
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: "gear")
                                .font(.title3)
                            Text("SETTINGS")
                                .font(.title3.bold())
                        }
                        .frame(width: 200, height: 48)
                        .background(
                            isDarkMode ?
                                Color.white.opacity(0.08) :
                                Color.white.opacity(0.6)
                        )
                        .foregroundColor(isDarkMode ? .white : Color(hex: "#1A0B2E"))
                        .cornerRadius(24)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color(hex: "#8A7CFF").opacity(0.5), lineWidth: 1)
                        )
                        .shadow(color: Color(hex: "#8A7CFF").opacity(0.2), radius: 5)
                    }
                    
                    Spacer()
                    
                    // MARK: - Version
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color(hex: "#B87CFF"))
                            .frame(width: 4, height: 4)
                        Text("Version 1.0.0")
                            .font(.caption2)
                            .foregroundColor(isDarkMode ? .white.opacity(0.4) : .purple.opacity(0.4))
                        Circle()
                            .fill(Color(hex: "#B87CFF"))
                            .frame(width: 4, height: 4)
                    }
                    .padding(.bottom, 30)
                }
                .padding(.horizontal, 20)
            }
            .navigationDestination(isPresented: $showGame) {
                GameView(difficulty: selectedDifficulty)
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

// MARK: - Difficulty Button Component - FIXED: Smaller text for longer words
struct DifficultyButton: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(isSelected ? .white : color)
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
                .minimumScaleFactor(0.8)  // Shrinks text if needed
                .lineLimit(1)  // Forces single line
                .fixedSize(horizontal: true, vertical: false)  // Prevents wrapping
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isSelected ? color : Color.white.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(color, lineWidth: isSelected ? 0 : 1)
                        )
                )
                .scaleEffect(isSelected ? 1.05 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
        }
        .fixedSize()  // Prevents button from being compressed
    }
}

#Preview {
    MainMenuView()
}
