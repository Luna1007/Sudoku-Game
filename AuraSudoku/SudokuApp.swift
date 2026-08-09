import SwiftUI

@main
struct SudokuApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @StateObject private var audioManager = AudioManager.shared
    
    var body: some Scene {
        WindowGroup {
            MainMenuView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .onAppear {
                    // Start music when app launches
                    audioManager.startMusic()
                }
        }
    }
}
