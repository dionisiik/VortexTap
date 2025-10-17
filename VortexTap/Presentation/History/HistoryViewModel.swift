import Foundation
import Combine

final class HistoryViewModel: ObservableObject {
    @Published var scores: [GameScore] = []
    @Published var bestCombo: Int = 0
    @Published var averageAccuracy: Double = 0
    
    private let repository = GameRepository()
    
    func loadData() {
        scores = repository.getScores().sorted { $0.date > $1.date }
        bestCombo = repository.getBestCombo()
        averageAccuracy = repository.getAverageAccuracy()
    }
}


