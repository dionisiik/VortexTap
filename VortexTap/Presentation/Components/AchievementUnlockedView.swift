import SwiftUI

struct AchievementUnlockedView: View {
    let achievements: [Achievement]
    let onDismiss: () -> Void
    
    @ObservedObject private var themeManager = ThemeManager.shared
    @State private var showContent = false
    @State private var currentIndex = 0
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let iconSize = screenWidth * 0.3
            
            ZStack {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                
                if currentIndex < achievements.count {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            Text("ACHIEVEMENT UNLOCKED!")
                                .font(.system(size: screenWidth * 0.04, weight: .bold, design: .rounded))
                                .foregroundColor(themeManager.colors.accent5)
                                .tracking(2)
                            
                            ZStack {
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            colors: [
                                                categoryColor.opacity(0.3),
                                                categoryColor.opacity(0.1),
                                                Color.clear
                                            ],
                                            center: .center,
                                            startRadius: iconSize * 0.33,
                                            endRadius: iconSize * 0.67
                                        )
                                    )
                                    .frame(width: iconSize * 1.33, height: iconSize * 1.33)
                                
                                Circle()
                                    .fill(themeManager.colors.secondaryBackground)
                                    .frame(width: iconSize, height: iconSize)
                                    .shadow(color: .black.opacity(0.4), radius: 20, x: 0, y: 10)
                                
                                Image(systemName: achievements[currentIndex].icon)
                                    .font(.system(size: iconSize * 0.42))
                                    .foregroundColor(categoryColor)
                            }
                            .scaleEffect(showContent ? 1.0 : 0.5)
                            
                            VStack(spacing: 8) {
                                Text(achievements[currentIndex].title)
                                    .font(.system(size: screenWidth * 0.06, weight: .black, design: .rounded))
                                    .foregroundColor(themeManager.colors.textPrimary)
                                    .multilineTextAlignment(.center)
                                
                                Text(achievements[currentIndex].description)
                                    .font(.system(size: screenWidth * 0.038, weight: .medium, design: .rounded))
                                    .foregroundColor(themeManager.colors.textSecondary)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        if achievements.count > 1 {
                            HStack(spacing: 8) {
                                ForEach(0..<achievements.count, id: \.self) { index in
                                    Circle()
                                        .fill(index == currentIndex ? categoryColor : themeManager.colors.textSecondary.opacity(0.3))
                                        .frame(width: screenWidth * 0.02, height: screenWidth * 0.02)
                                }
                            }
                        }
                        
                        Button(action: {
                            nextAchievement()
                        }) {
                            Text(achievements.count > 1 && currentIndex < achievements.count - 1 ? "Tap for next" : "Tap to continue")
                                .font(.system(size: screenWidth * 0.033, weight: .medium, design: .rounded))
                                .foregroundColor(themeManager.colors.textSecondary)
                                .opacity(0.7)
                                .padding(.vertical, 8)
                        }
                    }
                    .padding(32)
                    .background(
                        RoundedRectangle(cornerRadius: 28)
                            .fill(themeManager.colors.background)
                            .shadow(color: .black.opacity(0.5), radius: 30, x: 0, y: 15)
                    )
                    .padding(.horizontal, 40)
                    .opacity(showContent ? 1.0 : 0.0)
                    .scaleEffect(showContent ? 1.0 : 0.8)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        nextAchievement()
                    }
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                nextAchievement()
            }
            .onAppear {
                Haptics.shared.heavy()
                withAnimation(.spring(response: 0.8, dampingFraction: 0.75)) {
                    showContent = true
                }
            }
        }
    }
    
    private var categoryColor: Color {
        guard currentIndex < achievements.count else {
            return themeManager.colors.accent5
        }
        
        switch achievements[currentIndex].category {
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
    
    private func nextAchievement() {
        if currentIndex < achievements.count - 1 {
            withAnimation(.easeInOut(duration: 0.3)) {
                showContent = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                currentIndex += 1
                Haptics.shared.medium()
                withAnimation(.spring(response: 0.8, dampingFraction: 0.75)) {
                    showContent = true
                }
            }
        } else {
            Haptics.shared.light()
            onDismiss()
        }
    }
}

