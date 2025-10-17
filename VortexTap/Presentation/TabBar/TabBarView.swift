import SwiftUI

struct TabBarView: View {
    @State private var selectedTab: TabItem = .home
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Content
            Group {
                switch selectedTab {
                case .home:
                    HomeView()
                case .achievements:
                    AchievementsView()
                case .history:
                    HistoryView()
                case .settings:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Custom TabBar
            CustomTabBar(selectedTab: $selectedTab)
        }
        .background(themeManager.colors.background.ignoresSafeArea())
    }
}

