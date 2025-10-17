import SwiftUI

struct LoadingView: View {
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        ZStack {
            themeManager.colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    themeManager.colors.accent1,
                                    themeManager.colors.accent2,
                                    themeManager.colors.accent3
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 8
                        )
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(rotation))
                    
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    themeManager.colors.accent4,
                                    themeManager.colors.accent5
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 4
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(-rotation * 1.5))
                    
                    Circle()
                        .fill(themeManager.colors.primaryBackground)
                        .frame(width: 40, height: 40)
                        .scaleEffect(scale)
                }
                
                Text("VortexTap")
                    .font(AppTypography.largeTitle)
                    .foregroundColor(themeManager.colors.textPrimary)
                    .opacity(opacity)
                
                Text("Loading...")
                    .font(AppTypography.callout)
                    .foregroundColor(themeManager.colors.textSecondary)
                    .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                rotation = 360
            }
            
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                scale = 1.2
            }
            
            withAnimation(.easeOut(duration: 0.8)) {
                opacity = 1
            }
        }
    }
}

