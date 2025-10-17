import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        ZStack {
            themeManager.colors.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Title Label
                    Text("History")
                        .font(.system(size: 36, weight: .black, design: .rounded))
                        .foregroundColor(themeManager.colors.textPrimary)
                        .shadow(color: themeManager.colors.primaryBackground.opacity(0.5), radius: 12, x: 0, y: 4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    
                    VStack(spacing: 20) {
                        HStack(spacing: 16) {
                            StatCard(
                                title: "Best Combo",
                                value: "\(viewModel.bestCombo)",
                                icon: "flame.fill",
                                accentColor: themeManager.colors.accent1
                            )
                            
                            StatCard(
                                title: "Avg Accuracy",
                                value: "\(Int(viewModel.averageAccuracy))%",
                                icon: "target",
                                accentColor: themeManager.colors.accent2
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Recent Scores")
                                .font(AppTypography.title3)
                                .foregroundColor(themeManager.colors.textPrimary)
                                .padding(.horizontal, 20)
                            
                            if viewModel.scores.isEmpty {
                                VStack(spacing: 12) {
                                    Image(systemName: "chart.line.uptrend.xyaxis")
                                        .font(.system(size: 60))
                                        .foregroundColor(themeManager.colors.textSecondary.opacity(0.5))
                                    
                                    Text("No scores yet")
                                        .font(AppTypography.body)
                                        .foregroundColor(themeManager.colors.textSecondary)
                                    
                                    Text("Play a game to see your progress here!")
                                        .font(AppTypography.callout)
                                        .foregroundColor(themeManager.colors.textSecondary.opacity(0.7))
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 60)
                            } else {
                                ForEach(viewModel.scores) { score in
                                    ScoreCard(score: score)
                                        .padding(.horizontal, 20)
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
            viewModel.loadData()
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let accentColor: Color
    
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(accentColor)
            
            Text(value)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(themeManager.colors.textPrimary)
            
            Text(title)
                .font(AppTypography.caption)
                .foregroundColor(themeManager.colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(themeManager.colors.secondaryBackground)
        .cornerRadius(16)
    }
}

struct ScoreCard: View {
    let score: GameScore
    
    @ObservedObject private var themeManager = ThemeManager.shared
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, HH:mm"
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(score.mode.rawValue)
                        .font(AppTypography.headline)
                        .foregroundColor(themeManager.colors.textPrimary)
                    
                    Text(dateFormatter.string(from: score.date))
                        .font(AppTypography.caption)
                        .foregroundColor(themeManager.colors.textSecondary)
                }
                
                Spacer()
                
                Text("\(score.score)")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(themeManager.colors.accent5)
            }
            
            Divider()
                .background(themeManager.colors.textSecondary.opacity(0.2))
            
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Combo")
                        .font(AppTypography.caption)
                        .foregroundColor(themeManager.colors.textSecondary)
                    
                    Text("\(score.maxCombo)")
                        .font(AppTypography.headline)
                        .foregroundColor(themeManager.colors.textPrimary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Accuracy")
                        .font(AppTypography.caption)
                        .foregroundColor(themeManager.colors.textSecondary)
                    
                    Text("\(Int(score.accuracy))%")
                        .font(AppTypography.headline)
                        .foregroundColor(themeManager.colors.textPrimary)
                }
            }
        }
        .padding(20)
        .background(themeManager.colors.secondaryBackground)
        .cornerRadius(16)
    }
}

