import SwiftUI

final class AppCoordinator: ObservableObject {
    @Published var isLoading = true
    @Published var isOnboardingComplete = false
    
    init() {
        checkOnboardingStatus()
        startLoadingSequence()
    }
    
    private func checkOnboardingStatus() {
        isOnboardingComplete = UserDefaults.standard.bool(forKey: "onboarding_complete")
    }
    
    private func startLoadingSequence() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation {
                self.isLoading = false
            }
        }
    }
}


