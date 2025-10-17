import SwiftUI

struct ModeSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ModeSelectionViewModel()
    @ObservedObject private var themeManager = ThemeManager.shared
    @State private var showAnimation = false
    
    var body: some View {
        ZStack {
            // Animated Background
            LinearGradient(
                colors: [
                    themeManager.colors.background,
                    themeManager.colors.primaryBackground.opacity(0.1),
                    themeManager.colors.background
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Bar
                HStack {
                    Button(action: {
                        Haptics.shared.medium()
                        dismiss()
                    }) {
                        ZStack {
                            Circle()
                                .fill(themeManager.colors.secondaryBackground.opacity(0.8))
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(themeManager.colors.textPrimary)
                        }
                    }
                    
                    Spacer()
                    
                    Text("Choose Mode")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(themeManager.colors.textPrimary)
                    
                    Spacer()
                    
                    // Placeholder for symmetry
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 44, height: 44)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 8)
                
                ScrollView {
                    VStack(spacing: 40) {
                        Spacer()
                            .frame(height: 20)
                        
                        // Rhythm Mode Card
                        ModeCard(
                            title: "Rhythm Mode",
                            subtitle: "TIME CHALLENGE",
                            description: "Hit the beat for 60 seconds and maximize your combo!",
                            icon: "🎵",
                            stats: ["60 sec", "Score Attack", "Combo"],
                            accentColor: themeManager.colors.accent1,
                            gradientColors: [
                                themeManager.colors.accent1,
                                themeManager.colors.accent1.opacity(0.7)
                            ]
                        ) {
                            viewModel.selectRhythmMode()
                        }
                        .opacity(showAnimation ? 1 : 0)
                        .offset(y: showAnimation ? 0 : 40)
                        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.15), value: showAnimation)
                        
                        // Endless Mode Card
                        ModeCard(
                            title: "Endless Mode",
                            subtitle: "SURVIVAL",
                            description: "Survive as long as you can with increasing speed!",
                            icon: "♾️",
                            stats: ["3 Lives", "Speed Up", "Multiplier"],
                            accentColor: themeManager.colors.accent2,
                            gradientColors: [
                                themeManager.colors.accent2,
                                themeManager.colors.accent3
                            ]
                        ) {
                            viewModel.selectEndlessMode()
                        }
                        .opacity(showAnimation ? 1 : 0)
                        .offset(y: showAnimation ? 0 : 40)
                        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.25), value: showAnimation)
                        
                        // Orbital Mode Card
                        ModeCard(
                            title: "Orbital Mode",
                            subtitle: "DYNAMIC CHALLENGE",
                            description: "Switch orbits to catch the target on different rings!",
                            icon: "🌀",
                            stats: ["45 sec", "4 Orbits", "Switch"],
                            accentColor: themeManager.colors.accent4,
                            gradientColors: [
                                themeManager.colors.accent4,
                                themeManager.colors.accent5
                            ]
                        ) {
                            viewModel.selectOrbitalMode()
                        }
                        .opacity(showAnimation ? 1 : 0)
                        .offset(y: showAnimation ? 0 : 40)
                        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.35), value: showAnimation)
                        
                        Spacer()
                            .frame(height: 20)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.showRhythmMode) {
            RhythmModeView()
        }
        .fullScreenCover(isPresented: $viewModel.showEndlessMode) {
            EndlessModeView()
        }
        .fullScreenCover(isPresented: $viewModel.showOrbitalMode) {
            OrbitalModeView()
        }
        .onAppear {
            showAnimation = true
        }
    }
}

struct ModeCard: View {
    let title: String
    let subtitle: String
    let description: String
    let icon: String
    let stats: [String]
    let accentColor: Color
    let gradientColors: [Color]
    let action: () -> Void
    
    @ObservedObject private var themeManager = ThemeManager.shared
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            Haptics.shared.heavy()
            action()
        }) {
            VStack(spacing: 0) {
                // Top Section with Icon
                ZStack {
                    LinearGradient(
                        colors: gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    
                    VStack(spacing: 16) {
                        Text(icon)
                            .font(.system(size: 70))
                            .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                        
                        VStack(spacing: 4) {
                            Text(subtitle)
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                .foregroundColor(.white.opacity(0.9))
                                .tracking(2)
                            
                            Text(title)
                                .font(.system(size: 28, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                        }
                    }
                    .padding(.vertical, 40)
                }
                .frame(maxWidth: .infinity)
                .cornerRadius(24, corners: [.topLeft, .topRight])
                
                // Bottom Section with Info
                VStack(alignment: .leading, spacing: 16) {
                    Text(description)
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundColor(themeManager.colors.textSecondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    HStack(spacing: 12) {
                        ForEach(stats, id: \.self) { stat in
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(accentColor)
                                    .frame(width: 6, height: 6)
                                
                                Text(stat)
                                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                                    .foregroundColor(themeManager.colors.textPrimary)
                            }
                        }
                    }
                    
                    // Play Button
                    HStack {
                        Spacer()
                        
                        HStack(spacing: 8) {
                            Image(systemName: "play.fill")
                                .font(.system(size: 16, weight: .bold))
                            
                            Text("Play")
                                .font(.system(size: 17, weight: .bold, design: .rounded))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(
                                colors: gradientColors,
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(14)
                        .shadow(color: accentColor.opacity(0.5), radius: 12, x: 0, y: 4)
                        
                        Spacer()
                    }
                }
                .padding(24)
                .background(themeManager.colors.secondaryBackground)
                .cornerRadius(24, corners: [.bottomLeft, .bottomRight])
            }
            .background(themeManager.colors.secondaryBackground)
            .cornerRadius(24)
            .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        LinearGradient(
                            colors: [
                                accentColor.opacity(0.5),
                                Color.clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = false
                    }
                }
        )
    }
}

