import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        ZStack {
            // Animated Background
            LinearGradient(
                colors: [
                    themeManager.colors.background,
                    themeManager.colors.primaryBackground.opacity(0.05),
                    themeManager.colors.background
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                VStack(spacing: 50) {
                    // Logo/Title
                    VStack(spacing: 16) {
                        // Animated Circles
                        ZStack {
                            ForEach(0..<3, id: \.self) { index in
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            colors: [
                                                themeManager.colors.accent1.opacity(0.3),
                                                themeManager.colors.accent2.opacity(0.3),
                                                themeManager.colors.accent3.opacity(0.3)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 3
                                    )
                                    .frame(width: CGFloat(80 + index * 40), height: CGFloat(80 + index * 40))
                                    .rotationEffect(.degrees(Double(index) * 120))
                            }
                            
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            themeManager.colors.primaryBackground,
                                            themeManager.colors.primaryBackground.opacity(0.8)
                                        ],
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 30
                                    )
                                )
                                .frame(width: 60, height: 60)
                                .shadow(color: themeManager.colors.primaryBackground.opacity(0.6), radius: 20, x: 0, y: 0)
                        }
                        .frame(height: 200)
                        
                        Text("VortexTap")
                            .font(.system(size: 48, weight: .black, design: .rounded))
                            .foregroundColor(themeManager.colors.textPrimary)
                            .shadow(color: themeManager.colors.primaryBackground.opacity(0.5), radius: 16, x: 0, y: 4)
                        
                        Text("Circle Rhythm Game")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(themeManager.colors.textSecondary)
                            .tracking(2)
                    }
                    
                    // Start Button
                    Button(action: {
                        Haptics.shared.heavy()
                        viewModel.navigateToModeSelection()
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "play.fill")
                                .font(.system(size: 24, weight: .bold))
                            
                            Text("START")
                                .font(.system(size: 28, weight: .black, design: .rounded))
                                .tracking(2)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 70)
                        .background(
                            ZStack {
                                LinearGradient(
                                    colors: [
                                        themeManager.colors.primaryBackground,
                                        themeManager.colors.primaryBackground.opacity(0.8)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                                
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.3),
                                        Color.clear
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            }
                        )
                        .cornerRadius(20)
                        .shadow(color: themeManager.colors.primaryBackground.opacity(0.6), radius: 20, x: 0, y: 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.3),
                                            Color.clear
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    ),
                                    lineWidth: 2
                                )
                        )
                    }
                    .buttonStyle(ScaleButtonStyle())
                    .padding(.horizontal, 40)
                }
                
                Spacer()
                Spacer()
            }
            .padding(.bottom, 90)
        }
        .fullScreenCover(isPresented: $viewModel.showModeSelection) {
            ModeSelectionView()
        }
    }
}
