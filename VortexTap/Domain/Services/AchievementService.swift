import Foundation
import Combine

final class AchievementService: ObservableObject {
    static let shared = AchievementService()
    
    @Published var achievements: [Achievement] = []
    @Published var newlyUnlockedAchievements: [Achievement] = []
    
    private let achievementsKey = "user_achievements"
    
    private init() {
        loadAchievements()
    }
    
    private func loadAchievements() {
        if let data = UserDefaults.standard.data(forKey: achievementsKey),
           let saved = try? JSONDecoder().decode([Achievement].self, from: data) {
            achievements = saved
        } else {
            achievements = Achievement.all
            saveAchievements()
        }
    }
    
    private func saveAchievements() {
        if let encoded = try? JSONEncoder().encode(achievements) {
            UserDefaults.standard.set(encoded, forKey: achievementsKey)
        }
    }
    
    func checkAchievements(score: Int, combo: Int, accuracy: Double, mode: GameMode) {
        var newUnlocks: [Achievement] = []
        
        for index in achievements.indices {
            guard !achievements[index].isUnlocked else { continue }
            
            var shouldUnlock = false
            
            switch achievements[index].category {
            case .score:
                if score >= achievements[index].requirement {
                    shouldUnlock = true
                    achievements[index].currentProgress = score
                }
                
            case .combo:
                if combo >= achievements[index].requirement {
                    shouldUnlock = true
                    achievements[index].currentProgress = combo
                }
                
            case .accuracy:
                let accuracyInt = Int(accuracy)
                if accuracyInt >= achievements[index].requirement {
                    shouldUnlock = true
                    achievements[index].currentProgress = accuracyInt
                }
                
            case .games:
                achievements[index].currentProgress += 1
                if achievements[index].currentProgress >= achievements[index].requirement {
                    shouldUnlock = true
                }
                
            case .modes:
                switch achievements[index].id {
                case "mode_rhythm":
                    if mode == .rhythm {
                        shouldUnlock = true
                        achievements[index].currentProgress = 1
                    }
                case "mode_endless":
                    if mode == .endless && score >= achievements[index].requirement {
                        shouldUnlock = true
                        achievements[index].currentProgress = score
                    }
                case "mode_orbital":
                    if mode == .orbital && score >= achievements[index].requirement {
                        shouldUnlock = true
                        achievements[index].currentProgress = score
                    }
                case "mode_all":
                    updateModeAllProgress(mode: mode)
                    if achievements[index].currentProgress >= 3 {
                        shouldUnlock = true
                    }
                default:
                    break
                }
            }
            
            if shouldUnlock {
                achievements[index].isUnlocked = true
                achievements[index].unlockedDate = Date()
                newUnlocks.append(achievements[index])
            }
        }
        
        saveAchievements()
        
        if !newUnlocks.isEmpty {
            newlyUnlockedAchievements = newUnlocks
        }
    }
    
    private func updateModeAllProgress(mode: GameMode) {
        let modesPlayedKey = "modes_played"
        var modesPlayed = UserDefaults.standard.stringArray(forKey: modesPlayedKey) ?? []
        
        if !modesPlayed.contains(mode.rawValue) {
            modesPlayed.append(mode.rawValue)
            UserDefaults.standard.set(modesPlayed, forKey: modesPlayedKey)
            
            if let index = achievements.firstIndex(where: { $0.id == "mode_all" }) {
                achievements[index].currentProgress = modesPlayed.count
            }
        }
    }
    
    func getUnlockedCount() -> Int {
        return achievements.filter { $0.isUnlocked }.count
    }
    
    func getTotalCount() -> Int {
        return achievements.count
    }
    
    func clearNewAchievements() {
        newlyUnlockedAchievements.removeAll()
    }
    
    func resetAllAchievements() {
        achievements = Achievement.all
        saveAchievements()
    }
}


