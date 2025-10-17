import Foundation

struct Track: Identifiable {
    let id: UUID
    let name: String
    let difficulty: Difficulty
    let duration: TimeInterval
    let bpm: Int
    
    init(id: UUID = UUID(), name: String, difficulty: Difficulty, duration: TimeInterval, bpm: Int) {
        self.id = id
        self.name = name
        self.difficulty = difficulty
        self.duration = duration
        self.bpm = bpm
    }
}

enum Difficulty: String, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    case expert = "Expert"
}


