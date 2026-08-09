import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("isMusicOn") private var isMusicOn = false
    @Environment(\.dismiss) private var dismiss
    @State private var showRules = false
    @StateObject private var audioManager = AudioManager.shared
    
    var body: some View {
        ZStack {
            // Dynamic background
            if isDarkMode {
                LinearGradient(
                    colors: [Color(hex: "#1A0B2E"), Color(hex: "#2D1B4E")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            } else {
                LinearGradient(
                    colors: [Color(hex: "#F0E6FF"), Color(hex: "#E0D0FF")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            }
            
            VStack(spacing: 20) {
                // Header
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(isDarkMode ? .white.opacity(0.7) : .purple.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    Text("Settings")
                        .font(.title.bold())
                        .foregroundColor(isDarkMode ? .white : Color(hex: "#1A0B2E"))
                    
                    Spacer()
                    
                    Color.clear
                        .frame(width: 30)
                }
                .padding(.horizontal)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Rules & Instructions Button
                        Button(action: {
                            showRules = true
                        }) {
                            HStack {
                                Image(systemName: "book.fill")
                                    .font(.title2)
                                    .foregroundColor(Color(hex: "#B87CFF"))
                                    .frame(width: 40)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Rules & Instructions")
                                        .font(.headline)
                                        .foregroundColor(isDarkMode ? .white : Color(hex: "#1A0B2E"))
                                    
                                    Text("Learn how to play Sudoku")
                                        .font(.caption)
                                        .foregroundColor(isDarkMode ? .white.opacity(0.6) : .purple.opacity(0.6))
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(isDarkMode ? .white.opacity(0.5) : .purple.opacity(0.5))
                            }
                            .padding()
                            .background(
                                (isDarkMode ? Color.white.opacity(0.1) : Color.white)
                                    .shadow(color: .purple.opacity(0.1), radius: 5)
                            )
                            .cornerRadius(15)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        // Dark/Light Mode Toggle
                        HStack {
                            Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                                .font(.title2)
                                .foregroundColor(isDarkMode ? .purple : .orange)
                                .frame(width: 40)
                            
                            Text("Dark Mode")
                                .font(.headline)
                                .foregroundColor(isDarkMode ? .white : Color(hex: "#1A0B2E"))
                            
                            Spacer()
                            
                            Toggle("", isOn: $isDarkMode)
                                .toggleStyle(SwitchToggleStyle(tint: Color(hex: "#8A7CFF")))
                                .onChange(of: isDarkMode) { oldValue, newValue in
                                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                                        windowScene.windows.first?.overrideUserInterfaceStyle = newValue ? .dark : .light
                                    }
                                }
                        }
                        .padding()
                        .background(
                            (isDarkMode ? Color.white.opacity(0.1) : Color.white)
                                .shadow(color: .purple.opacity(0.1), radius: 5)
                        )
                        .cornerRadius(15)
                        
                        // Background Music Toggle
                        HStack {
                            Image(systemName: "music.note")
                                .font(.title2)
                                .foregroundColor(Color(hex: "#B87CFF"))
                                .frame(width: 40)
                            
                            Text("Background Music")
                                .font(.headline)
                                .foregroundColor(isDarkMode ? .white : Color(hex: "#1A0B2E"))
                            
                            Spacer()
                            
                            Toggle("", isOn: $isMusicOn)
                                .toggleStyle(SwitchToggleStyle(tint: Color(hex: "#8A7CFF")))
                                .onChange(of: isMusicOn) { oldValue, newValue in
                                    if oldValue != newValue {
                                        audioManager.toggleBackgroundMusic()
                                    }
                                }
                        }
                        .padding()
                        .background(
                            (isDarkMode ? Color.white.opacity(0.1) : Color.white)
                                .shadow(color: .purple.opacity(0.1), radius: 5)
                        )
                        .cornerRadius(15)
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                // App Info
                VStack(spacing: 10) {
                    Text("AuraSudoku")
                        .font(.headline)
                        .foregroundColor(Color(hex: "#8A7CFF"))
                    Text("Version 1.0.0")
                        .font(.caption)
                        .foregroundColor(isDarkMode ? .white.opacity(0.5) : .purple.opacity(0.5))
                }
                .padding(.bottom, 20)
            }
            .padding()
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .sheet(isPresented: $showRules) {
            RulesView()
        }
    }
}

// MARK: - Rules View
struct RulesView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // Background
            (isDarkMode ? Color(hex: "#1A0B2E") : Color(hex: "#F0E6FF"))
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Rules & Instructions")
                        .font(.title2.bold())
                        .foregroundColor(isDarkMode ? .white : Color(hex: "#1A0B2E"))
                    
                    Spacer()
                    
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(isDarkMode ? .white.opacity(0.7) : .purple.opacity(0.7))
                    }
                }
                .padding()
                .background(isDarkMode ? Color(hex: "#2A1A4E") : Color.white)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        // What is Sudoku
                        RuleSection(
                            title: "📖 What is Sudoku?",
                            content: "Sudoku is a logic-based number puzzle game. The goal is to fill a 9x9 grid with numbers so that each column, each row, and each of the nine 3x3 boxes contains all digits from 1 to 9 exactly once.",
                            isDarkMode: isDarkMode
                        )
                        
                        // Basic Rules
                        RuleSection(
                            title: "🎯 Basic Rules",
                            content: "• Each row must contain numbers 1-9 without repetition\n• Each column must contain numbers 1-9 without repetition\n• Each 3x3 box must contain numbers 1-9 without repetition",
                            isDarkMode: isDarkMode
                        )
                        
                        // How to Play
                        RuleSection(
                            title: "🎮 How to Play",
                            content: "1. Tap on any empty cell to select it\n2. Use the number pad (1-9) to fill the cell\n3. Use Erase button to clear a cell\n4. Use Hint button for help\n5. Use Check button to verify your solution",
                            isDarkMode: isDarkMode
                        )
                        
                        // Tips
                        RuleSection(
                            title: "💡 Tips for Beginners",
                            content: "• Start with easy difficulty\n• Look for rows, columns, or boxes with many numbers already filled\n• Take your time - there's no time limit\n• Use the Hint button when stuck",
                            isDarkMode: isDarkMode
                        )
                        
                        // Difficulty Levels
                        RuleSection(
                            title: "⭐ Difficulty Levels",
                            content: "• Easy: More numbers pre-filled (around 40 missing)\n• Medium: Moderate challenge (around 50 missing)\n• Hard: Fewer hints (around 60 missing)\n• Expert: Very challenging (around 70 missing)\n• Random: Surprise difficulty every game",
                            isDarkMode: isDarkMode
                        )
                        
                        // Features
                        RuleSection(
                            title: "✨ AuraSudoku Features",
                            content: "• Beautiful purple theme\n• Dark/Light mode support\n• Timer to track your progress\n• Hint system for help\n• Check solution button\n• Pause and resume game\n• Background music\n• Multiple difficulty levels",
                            isDarkMode: isDarkMode
                        )
                    }
                    .padding()
                }
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

// MARK: - Rule Section Component
struct RuleSection: View {
    let title: String
    let content: String
    let isDarkMode: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3.bold())
                .foregroundColor(Color(hex: "#B87CFF"))
            
            Text(content)
                .font(.body)
                .foregroundColor(isDarkMode ? .white.opacity(0.9) : Color(hex: "#1A0B2E").opacity(0.8))
                .lineSpacing(5)
        }
        .padding()
        .background(
            (isDarkMode ? Color.white.opacity(0.05) : Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color(hex: "#8A7CFF").opacity(0.3), lineWidth: 1)
                )
        )
        .cornerRadius(15)
    }
}
