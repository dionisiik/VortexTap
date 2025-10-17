import SwiftUI

@main
struct VortexTapApp: App {
    @StateObject private var coordinator = AppCoordinator()
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some Scene {
        WindowGroup {
            Group {
                if coordinator.isLoading {
                    LoadingView()
                } else if !coordinator.isOnboardingComplete {
                    OnboardingView(isOnboardingComplete: $coordinator.isOnboardingComplete)
                } else {
                    TabBarView()
                }
            }
            .environmentObject(themeManager)
        }
    }
}
