import Foundation
import Combine

final class SettingsViewModel: ObservableObject {
    @Published var selectedTheme: AppTheme
    @Published var soundEnabled: Bool
    @Published var notificationsEnabled: Bool
    @Published var hapticEnabled: Bool
    
    private let themeManager = ThemeManager.shared
    private let soundService = SoundService.shared
    private let notificationService = NotificationService.shared
    private let hapticService = HapticService.shared
    
    init() {
        self.selectedTheme = themeManager.currentTheme
        self.soundEnabled = soundService.isSoundEnabled
        self.notificationsEnabled = notificationService.isNotificationsEnabled
        self.hapticEnabled = hapticService.isHapticEnabled
    }
    
    func selectTheme(_ theme: AppTheme) {
        selectedTheme = theme
        themeManager.setTheme(theme)
        Haptics.shared.selection()
    }
    
    func toggleSound() {
        soundService.toggleSound()
    }
    
    func toggleNotifications() {
        notificationService.toggleNotifications()
    }
    
    func toggleHaptic() {
        hapticService.toggleHaptic()
    }
}

