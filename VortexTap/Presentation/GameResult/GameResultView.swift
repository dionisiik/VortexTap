import SwiftUI

struct GameResultView: View {
    let score: Int
    let accuracy: Double
    let maxCombo: Int
    let hits: Int
    let totalTaps: Int
    let mode: GameMode
    let onPlayAgain: () -> Void
    let onHome: () -> Void
    
    @ObservedObject private var themeManager = ThemeManager.shared
    @ObservedObject private var achievementService = AchievementService.shared
    @State private var showContent = false
    @State private var showAchievements = false
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            
            ZStack {
                themeManager.colors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Title
                        Text(resultTitle)
                            .font(.system(size: screenWidth * 0.09, weight: .black, design: .rounded))
                            .foregroundColor(themeManager.colors.textPrimary)
                            .shadow(color: resultColor.opacity(0.5), radius: 12, x: 0, y: 4)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        
                        // Score Card
                        VStack(spacing: 16) {
                            VStack(spacing: 8) {
                                Text("SCORE")
                                    .font(.system(size: screenWidth * 0.03, weight: .bold, design: .rounded))
                                    .foregroundColor(themeManager.colors.textSecondary)
                                    .tracking(2)
                                
                                Text("\(score)")
                                    .font(.system(size: screenWidth * 0.12, weight: .black, design: .rounded))
                                    .foregroundColor(themeManager.colors.accent5)
                                    .shadow(color: themeManager.colors.accent5.opacity(0.6), radius: 12, x: 0, y: 0)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 30)
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(themeManager.colors.secondaryBackground)
                                    .shadow(color: .black.opacity(0.3), radius: 16, x: 0, y: 8)
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        // Stats Grid
                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                CompactStatBox(
                                    icon: "flame.fill",
                                    title: "COMBO",
                                    value: "\(maxCombo)",
                                    color: themeManager.colors.accent1,
                                    screenWidth: screenWidth
                                )
                                
                                CompactStatBox(
                                    icon: "target",
                                    title: "ACCURACY",
                                    value: "\(Int(accuracy))%",
                                    color: themeManager.colors.accent4,
                                    screenWidth: screenWidth
                                )
                            }
                            
                            HStack(spacing: 12) {
                                CompactStatBox(
                                    icon: "hand.tap.fill",
                                    title: "HITS",
                                    value: "\(hits)/\(totalTaps)",
                                    color: themeManager.colors.accent3,
                                    screenWidth: screenWidth
                                )
                                
                                CompactStatBox(
                                    icon: mode == .rhythm ? "clock.fill" : "infinity",
                                    title: "MODE",
                                    value: mode.rawValue,
                                    color: themeManager.colors.accent2,
                                    screenWidth: screenWidth
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Buttons
                        VStack(spacing: 12) {
                            Button(action: {
                                Haptics.shared.heavy()
                                Haptics.shared.success()
                                onPlayAgain()
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "arrow.clockwise")
                                        .font(.system(size: screenWidth * 0.045, weight: .bold))
                                    
                                    Text("PLAY AGAIN")
                                        .font(.system(size: screenWidth * 0.045, weight: .bold, design: .rounded))
                                        .tracking(1)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: screenWidth * 0.14)
                                .background(themeManager.colors.primaryBackground)
                                .cornerRadius(16)
                                .shadow(color: themeManager.colors.primaryBackground.opacity(0.4), radius: 12, x: 0, y: 6)
                            }
                            .buttonStyle(ScaleButtonStyle())
                            
                            Button(action: {
                                Haptics.shared.medium()
                                onHome()
                            }) {
                                Text("HOME")
                                    .font(.system(size: screenWidth * 0.043, weight: .semibold, design: .rounded))
                                    .foregroundColor(themeManager.colors.textPrimary)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: screenWidth * 0.13)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(themeManager.colors.secondaryBackground.opacity(0.8))
                                    )
                            }
                            .buttonStyle(ScaleButtonStyle())
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.vertical, 20)
                    .padding(.bottom, 20)
                }
            }
        }
        .onAppear {
            achievementService.checkAchievements(score: score, combo: maxCombo, accuracy: accuracy, mode: mode)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                if !achievementService.newlyUnlockedAchievements.isEmpty {
                    showAchievements = true
                }
            }
        }
        .overlay(
            Group {
                if showAchievements && !achievementService.newlyUnlockedAchievements.isEmpty {
                    AchievementUnlockedView(
                        achievements: achievementService.newlyUnlockedAchievements,
                        onDismiss: {
                            showAchievements = false
                            achievementService.clearNewAchievements()
                        }
                    )
                    .transition(.opacity)
                }
            }
        )
    }
    
    private var resultTitle: String {
        if accuracy >= 90 {
            return "PERFECT!"
        } else if accuracy >= 70 {
            return "GREAT!"
        } else if accuracy >= 50 {
            return "GOOD!"
        } else {
            return "COMPLETE!"
        }
    }
    
    private var resultColor: Color {
        if accuracy >= 90 {
            return themeManager.colors.accent3
        } else if accuracy >= 70 {
            return themeManager.colors.accent2
        } else if accuracy >= 50 {
            return themeManager.colors.accent4
        } else {
            return themeManager.colors.accent1
        }
    }
}

struct CompactStatBox: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    let screenWidth: CGFloat
    
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: screenWidth * 0.05))
                .foregroundColor(color)
                .frame(width: screenWidth * 0.08)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: screenWidth * 0.025, weight: .bold, design: .rounded))
                    .foregroundColor(themeManager.colors.textSecondary)
                    .tracking(1)
                
                Text(value)
                    .font(.system(size: screenWidth * 0.05, weight: .bold, design: .rounded))
                    .foregroundColor(themeManager.colors.textPrimary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(themeManager.colors.secondaryBackground)
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        )
    }
}

