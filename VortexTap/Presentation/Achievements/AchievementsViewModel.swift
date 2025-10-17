import Foundation
import Combine

final class AchievementsViewModel: ObservableObject {
    @Published var achievements: [Achievement] = []
    
    private let achievementService = AchievementService.shared
    private var cancellables = Set<AnyCancellable>()
    
    var unlockedCount: Int {
        achievementService.getUnlockedCount()
    }
    
    var totalCount: Int {
        achievementService.getTotalCount()
    }
    
    var progressPercentage: Int {
        guard totalCount > 0 else { return 0 }
        return Int((Double(unlockedCount) / Double(totalCount)) * 100)
    }
    
    init() {
        achievementService.$achievements
            .sink { [weak self] achievements in
                self?.achievements = achievements
            }
            .store(in: &cancellables)
    }
    
    func loadAchievements() {
        achievements = achievementService.achievements
    }
    
    func achievements(for category: AchievementCategory) -> [Achievement] {
        return achievements.filter { $0.category == category }
    }
}


