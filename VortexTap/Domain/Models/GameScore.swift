import Foundation

struct GameScore: Codable, Identifiable {
    let id: UUID
    let score: Int
    let accuracy: Double
    let maxCombo: Int
    let mode: GameMode
    let date: Date
    
    init(id: UUID = UUID(), score: Int, accuracy: Double, maxCombo: Int, mode: GameMode, date: Date = Date()) {
        self.id = id
        self.score = score
        self.accuracy = accuracy
        self.maxCombo = maxCombo
        self.mode = mode
        self.date = date
    }
}

enum GameMode: String, Codable {
    case rhythm = "Rhythm"
    case endless = "Endless"
    case orbital = "Orbital"
}
