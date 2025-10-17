import SwiftUI

struct AchievementsView: View {
    @StateObject private var viewModel = AchievementsViewModel()
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        ZStack {
            themeManager.colors.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    Text("Achievements")
                        .font(.system(size: 36, weight: .black, design: .rounded))
                        .foregroundColor(themeManager.colors.textPrimary)
                        .shadow(color: themeManager.colors.primaryBackground.opacity(0.5), radius: 12, x: 0, y: 4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    
                    HStack(spacing: 16) {
                        StatBox(
                            icon: "trophy.fill",
                            title: "UNLOCKED",
                            value: "\(viewModel.unlockedCount)/\(viewModel.totalCount)",
                            color: themeManager.colors.accent5
                        )
                        
                        StatBox(
                            icon: "percent",
                            title: "PROGRESS",
                            value: "\(viewModel.progressPercentage)%",
                            color: themeManager.colors.accent3
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(AchievementCategory.allCases, id: \.self) { category in
                            if viewModel.achievements(for: category).count > 0 {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(category.rawValue)
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                        .foregroundColor(themeManager.colors.textPrimary)
                                        .padding(.horizontal, 20)
                                    
                                    ForEach(viewModel.achievements(for: category)) { achievement in
                                        AchievementCard(achievement: achievement)
                                            .padding(.horizontal, 20)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.vertical, 20)
                .padding(.bottom, 90)
            }
        }
        .onAppear {
            viewModel.loadAchievements()
        }
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        achievement.isUnlocked
                            ? categoryColor.opacity(0.2)
                            : themeManager.colors.textSecondary.opacity(0.1)
                    )
                    .frame(width: 60, height: 60)
                
                Image(systemName: achievement.icon)
                    .font(.system(size: 26))
                    .foregroundColor(
                        achievement.isUnlocked
                            ? categoryColor
                            : themeManager.colors.textSecondary.opacity(0.4)
                    )
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(achievement.title)
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(
                        achievement.isUnlocked
                            ? themeManager.colors.textPrimary
                            : themeManager.colors.textSecondary.opacity(0.6)
                    )
                
                Text(achievement.description)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(themeManager.colors.textSecondary)
                    .lineLimit(2)
                
                if !achievement.isUnlocked {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(achievement.progressText)
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .foregroundColor(themeManager.colors.textSecondary)
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(themeManager.colors.textSecondary.opacity(0.2))
                                    .frame(height: 6)
                                
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(categoryColor)
                                    .frame(width: geometry.size.width * achievement.progress, height: 6)
                            }
                        }
                        .frame(height: 6)
                    }
                } else if let date = achievement.unlockedDate {
                    Text("Unlocked " + formatDate(date))
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundColor(categoryColor)
                }
            }
            
            Spacer()
            
            if achievement.isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(categoryColor)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(themeManager.colors.secondaryBackground)
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            achievement.isUnlocked
                                ? categoryColor.opacity(0.3)
                                : Color.clear,
                            lineWidth: 2
                        )
                )
        )
        .opacity(achievement.isUnlocked ? 1.0 : 0.7)
    }
    
    private var categoryColor: Color {
        switch achievement.category {
        case .score:
            return themeManager.colors.accent5
        case .combo:
            return themeManager.colors.accent1
        case .accuracy:
            return themeManager.colors.accent4
        case .games:
            return themeManager.colors.accent3
        case .modes:
            return themeManager.colors.accent2
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

struct StatBox: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 28, weight: .black, design: .rounded))
                .foregroundColor(themeManager.colors.textPrimary)
            
            Text(title)
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundColor(themeManager.colors.textSecondary)
                .tracking(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(themeManager.colors.secondaryBackground)
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        )
    }
}


