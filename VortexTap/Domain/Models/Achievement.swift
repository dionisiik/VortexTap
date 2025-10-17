import Foundation

struct Achievement: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let category: AchievementCategory
    let requirement: Int
    var currentProgress: Int = 0
    var isUnlocked: Bool = false
    var unlockedDate: Date?
    
    var progress: Double {
        return min(Double(currentProgress) / Double(requirement), 1.0)
    }
    
    var progressText: String {
        return "\(currentProgress)/\(requirement)"
    }
}

enum AchievementCategory: String, Codable, CaseIterable {
    case score = "Score"
    case combo = "Combo"
    case accuracy = "Accuracy"
    case games = "Games Played"
    case modes = "Modes"
}

extension Achievement {
    static let all: [Achievement] = [
        // Score Achievements
        Achievement(id: "score_500", title: "Getting Started", description: "Score 500 points in any mode", icon: "star.fill", category: .score, requirement: 500),
        Achievement(id: "score_1000", title: "Rising Star", description: "Score 1000 points in any mode", icon: "star.circle.fill", category: .score, requirement: 1000),
        Achievement(id: "score_2500", title: "High Scorer", description: "Score 2500 points in any mode", icon: "flame.fill", category: .score, requirement: 2500),
        Achievement(id: "score_5000", title: "Score Master", description: "Score 5000 points in any mode", icon: "crown.fill", category: .score, requirement: 5000),
        
        // Combo Achievements
        Achievement(id: "combo_10", title: "Combo Starter", description: "Reach a combo of 10", icon: "link", category: .combo, requirement: 10),
        Achievement(id: "combo_25", title: "Combo Builder", description: "Reach a combo of 25", icon: "link.circle.fill", category: .combo, requirement: 25),
        Achievement(id: "combo_50", title: "Combo Expert", description: "Reach a combo of 50", icon: "bolt.fill", category: .combo, requirement: 50),
        Achievement(id: "combo_100", title: "Combo Legend", description: "Reach a combo of 100", icon: "bolt.heart.fill", category: .combo, requirement: 100),
        
        // Accuracy Achievements
        Achievement(id: "accuracy_70", title: "Sharp Eye", description: "Complete a game with 70%+ accuracy", icon: "eye.fill", category: .accuracy, requirement: 70),
        Achievement(id: "accuracy_90", title: "Sharpshooter", description: "Complete a game with 90%+ accuracy", icon: "scope", category: .accuracy, requirement: 90),
        Achievement(id: "accuracy_100", title: "Perfect Shot", description: "Complete a game with 100% accuracy", icon: "target", category: .accuracy, requirement: 100),
        
        // Games Played
        Achievement(id: "games_1", title: "First Steps", description: "Complete your first game", icon: "play.fill", category: .games, requirement: 1),
        Achievement(id: "games_10", title: "Regular Player", description: "Complete 10 games", icon: "gamecontroller.fill", category: .games, requirement: 10),
        Achievement(id: "games_50", title: "Dedicated", description: "Complete 50 games", icon: "trophy.fill", category: .games, requirement: 50),
        Achievement(id: "games_100", title: "Veteran", description: "Complete 100 games", icon: "medal.fill", category: .games, requirement: 100),
        
        // Modes
        Achievement(id: "mode_rhythm", title: "Rhythm Master", description: "Complete Rhythm Mode", icon: "music.note", category: .modes, requirement: 1),
        Achievement(id: "mode_endless", title: "Survivor", description: "Score 1000+ in Endless Mode", icon: "infinity.circle.fill", category: .modes, requirement: 1000),
        Achievement(id: "mode_orbital", title: "Orbital Champion", description: "Score 1500+ in Orbital Mode", icon: "circle.hexagongrid.fill", category: .modes, requirement: 1500),
        Achievement(id: "mode_all", title: "Triple Threat", description: "Play all 3 modes", icon: "3.circle.fill", category: .modes, requirement: 3)
    ]
}

