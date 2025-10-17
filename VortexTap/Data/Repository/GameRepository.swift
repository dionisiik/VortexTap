import Foundation
import Combine

protocol GameRepositoryProtocol {
    func saveScore(_ score: GameScore)
    func getScores() -> [GameScore]
    func getBestCombo() -> Int
    func getAverageAccuracy() -> Double
}

final class GameRepository: GameRepositoryProtocol {
    private let userDefaults = UserDefaults.standard
    private let scoresKey = "game_scores"
    
    func saveScore(_ score: GameScore) {
        var scores = getScores()
        scores.append(score)
        
        if scores.count > 50 {
            scores = Array(scores.suffix(50))
        }
        
        if let encoded = try? JSONEncoder().encode(scores) {
            userDefaults.set(encoded, forKey: scoresKey)
        }
    }
    
    func getScores() -> [GameScore] {
        guard let data = userDefaults.data(forKey: scoresKey),
              let scores = try? JSONDecoder().decode([GameScore].self, from: data) else {
            return []
        }
        return scores
    }
    
    func getBestCombo() -> Int {
        let scores = getScores()
        return scores.map { $0.maxCombo }.max() ?? 0
    }
    
    func getAverageAccuracy() -> Double {
        let scores = getScores()
        guard !scores.isEmpty else { return 0 }
        let sum = scores.reduce(0.0) { $0 + $1.accuracy }
        return sum / Double(scores.count)
    }
}


