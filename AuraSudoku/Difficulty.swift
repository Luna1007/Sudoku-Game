import SwiftUI

enum Difficulty: String, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    case expert = "Expert"
    case random = "Random"
    
    var color: Color {
        switch self {
        case .easy: return Color(hex: "#7CFF9E")
        case .medium: return Color(hex: "#FFD47C")
        case .hard: return Color(hex: "#FF9E7C")
        case .expert: return Color(hex: "#FF7C7C")
        case .random: return Color(hex: "#C97CFF")
        }
    }
    
    var cellsToRemove: Int {
        switch self {
        case .easy: return 40
        case .medium: return 50
        case .hard: return 60
        case .expert: return 70
        case .random: return Int.random(in: 40...70)
        }
    }
}

