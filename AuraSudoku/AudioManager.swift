import SwiftUI
import AVFoundation
import Combine

class AudioManager: NSObject, ObservableObject {
    static let shared = AudioManager()
    
    private var audioPlayer: AVAudioPlayer?
    @AppStorage("isMusicOn") private var isMusicOn = false
    
    override private init() {
        super.init()
        setupAudioSession()
        loadBackgroundMusic()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    private func loadBackgroundMusic() {
        guard let url = Bundle.main.url(forResource: "bg-music", withExtension: "mp3") else {
            print("❌ bg-music.mp3 not found")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.volume = 0.4
            
            if isMusicOn {
                audioPlayer?.play()
                print("✅ Background music playing")
            }
        } catch {
            print("Failed to load music: \(error)")
        }
    }
    
    func toggleBackgroundMusic() {
        if isMusicOn {
            audioPlayer?.play()
            print("🎵 Music ON")
        } else {
            audioPlayer?.pause()
            print("🔇 Music OFF")
        }
    }
    
    func startMusic() {
        if isMusicOn && audioPlayer?.isPlaying == false {
            audioPlayer?.play()
        }
    }
}
