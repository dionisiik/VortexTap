import SwiftUI

struct RhythmModeView: View {
    @StateObject private var viewModel = RhythmModeViewModel()
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var themeManager = ThemeManager.shared
    @State private var particleScale: CGFloat = 1.0
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            let timerSize = min(screenWidth, screenHeight) * 0.12
            let gameAreaSize = min(screenWidth * 0.95, screenHeight * 0.5)
            
            ZStack {
                LinearGradient(
                    colors: [
                        themeManager.colors.background,
                        themeManager.colors.secondaryBackground.opacity(0.5)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Top Bar
                    VStack(spacing: 12) {
                        // Timer
                        ZStack {
                            Circle()
                                .stroke(
                                    themeManager.colors.textSecondary.opacity(0.2),
                                    lineWidth: 6
                                )
                                .frame(width: timerSize, height: timerSize)
                        
                            Circle()
                                .trim(from: 0, to: CGFloat(viewModel.timeRemaining) / 60.0)
                                .stroke(
                                    LinearGradient(
                                        colors: viewModel.timeRemaining > 10 
                                            ? [themeManager.colors.accent3, themeManager.colors.accent2]
                                            : [themeManager.colors.accent1, themeManager.colors.accent4],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                                )
                                .frame(width: timerSize, height: timerSize)
                            .rotationEffect(.degrees(-90))
                            .shadow(
                                color: viewModel.timeRemaining > 10 
                                    ? themeManager.colors.accent3.opacity(0.6)
                                    : themeManager.colors.accent1.opacity(0.6),
                                radius: 8,
                                x: 0,
                                y: 2
                            )
                            
                            VStack(spacing: 2) {
                                Text("\(viewModel.timeRemaining)")
                                    .font(.system(size: timerSize * 0.35, weight: .black, design: .rounded))
                                    .foregroundColor(themeManager.colors.textPrimary)
                                
                                Text("SEC")
                                    .font(.system(size: timerSize * 0.11, weight: .bold, design: .rounded))
                                    .foregroundColor(themeManager.colors.textSecondary)
                                    .tracking(1)
                            }
                        }
                            .scaleEffect(viewModel.timeRemaining <= 10 && viewModel.timeRemaining > 0 ? 1.08 : 1.0)
                        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: viewModel.timeRemaining)
                        
                        // Stats Bar
                        HStack {
                            Button(action: {
                                Haptics.shared.medium()
                                dismiss()
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(themeManager.colors.secondaryBackground.opacity(0.8))
                                        .frame(width: screenWidth * 0.11, height: screenWidth * 0.11)
                                    
                                    Image(systemName: "xmark")
                                        .font(.system(size: screenWidth * 0.04, weight: .bold))
                                        .foregroundColor(themeManager.colors.textPrimary)
                                }
                            }
                            
                            Spacer()
                            
                            // Score Display
                            VStack(spacing: 2) {
                                Text("SCORE")
                                    .font(.system(size: screenWidth * 0.025, weight: .bold, design: .rounded))
                                    .foregroundColor(themeManager.colors.textSecondary)
                                    .tracking(2)
                                
                                Text("\(viewModel.score)")
                                    .font(.system(size: screenWidth * 0.055, weight: .bold, design: .rounded))
                                    .foregroundColor(themeManager.colors.accent5)
                                    .shadow(color: themeManager.colors.accent5.opacity(0.5), radius: 8, x: 0, y: 2)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(themeManager.colors.secondaryBackground.opacity(0.8))
                                    .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 3)
                            )
                            
                            Spacer()
                            
                            // Combo Display
                            VStack(spacing: 2) {
                                Text("COMBO")
                                    .font(.system(size: screenWidth * 0.025, weight: .bold, design: .rounded))
                                    .foregroundColor(themeManager.colors.textSecondary)
                                    .tracking(2)
                                
                                Text("\(viewModel.combo)")
                                    .font(.system(size: screenWidth * 0.055, weight: .bold, design: .rounded))
                                    .foregroundColor(themeManager.colors.accent1)
                                    .shadow(color: themeManager.colors.accent1.opacity(0.5), radius: 8, x: 0, y: 2)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(themeManager.colors.secondaryBackground.opacity(0.8))
                                    .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 3)
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                    
                    Spacer()
                    
                    // Game Area
                    ZStack {
                        let orbitRadius = gameAreaSize * 0.34
                        let targetSize = gameAreaSize * 0.2
                        let movingPointSize = gameAreaSize * 0.07
                        let centerPointSize = gameAreaSize * 0.125
                        
                        // Background glow
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        themeManager.colors.primaryBackground.opacity(0.15),
                                        Color.clear
                                    ],
                                    center: .center,
                                    startRadius: gameAreaSize * 0.125,
                                    endRadius: gameAreaSize * 0.5
                                )
                            )
                            .frame(width: gameAreaSize, height: gameAreaSize)
                        
                        // Outer circles with gradients
                        ForEach(0..<4, id: \.self) { index in
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            themeManager.colors.accent1.opacity(0.3),
                                            themeManager.colors.accent2.opacity(0.2),
                                            themeManager.colors.accent3.opacity(0.1)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                                .frame(width: gameAreaSize * (0.3 + CGFloat(index) * 0.125), height: gameAreaSize * (0.3 + CGFloat(index) * 0.125))
                                .shadow(color: themeManager.colors.primaryBackground.opacity(0.3), radius: 4, x: 0, y: 2)
                        }
                        
                        // Target zone with glow effect (dynamic position)
                        ZStack {
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            themeManager.colors.accent2.opacity(0.6),
                                            themeManager.colors.accent2.opacity(0.3),
                                            themeManager.colors.accent2.opacity(0.1)
                                        ],
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: targetSize * 0.5
                                    )
                                )
                                .frame(width: targetSize, height: targetSize)
                            
                            Circle()
                                .stroke(themeManager.colors.accent2, lineWidth: 3)
                                .frame(width: targetSize * 0.875, height: targetSize * 0.875)
                            
                            Image(systemName: "scope")
                                .font(.system(size: targetSize * 0.375))
                                .foregroundColor(themeManager.colors.accent2)
                        }
                        .offset(
                            x: cos(viewModel.targetPosition * .pi / 180) * orbitRadius,
                            y: sin(viewModel.targetPosition * .pi / 180) * orbitRadius
                        )
                        .shadow(color: themeManager.colors.accent2.opacity(0.6), radius: 12, x: 0, y: 4)
                        
                        // Moving point with trail
                        ZStack {
                            // Trail effect
                            ForEach(0..<3, id: \.self) { i in
                                Circle()
                                    .fill(
                                        viewModel.targetHit ? themeManager.colors.accent3.opacity(0.3) : themeManager.colors.primaryBackground.opacity(0.3)
                                    )
                                    .frame(width: movingPointSize * (1.0 - CGFloat(i) * 0.2), height: movingPointSize * (1.0 - CGFloat(i) * 0.2))
                                    .offset(
                                        x: cos((viewModel.rotation - Double(i * 10)) * .pi / 180) * orbitRadius,
                                        y: sin((viewModel.rotation - Double(i * 10)) * .pi / 180) * orbitRadius
                                    )
                            }
                            
                            // Main point
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            viewModel.targetHit ? themeManager.colors.accent3 : themeManager.colors.primaryBackground,
                                            viewModel.targetHit ? themeManager.colors.accent3.opacity(0.7) : themeManager.colors.primaryBackground.opacity(0.7)
                                        ],
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: movingPointSize * 0.5
                                    )
                                )
                                .frame(width: movingPointSize, height: movingPointSize)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.8), lineWidth: 2)
                                )
                                .shadow(
                                    color: viewModel.targetHit ? themeManager.colors.accent3 : themeManager.colors.primaryBackground,
                                    radius: 12,
                                    x: 0,
                                    y: 0
                                )
                                .offset(
                                    x: cos(viewModel.rotation * .pi / 180) * orbitRadius,
                                    y: sin(viewModel.rotation * .pi / 180) * orbitRadius
                                )
                                .scaleEffect(viewModel.targetHit ? 1.3 : 1.0)
                        }
                        
                        // Center point
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        themeManager.colors.accent1,
                                        themeManager.colors.accent1.opacity(0.8)
                                    ],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: centerPointSize * 0.5
                                )
                            )
                            .frame(width: centerPointSize, height: centerPointSize)
                            .overlay(
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            colors: [themeManager.colors.accent5, themeManager.colors.accent2],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 3
                                    )
                            )
                            .shadow(color: themeManager.colors.accent1.opacity(0.6), radius: 16, x: 0, y: 0)
                        
                        // Hit particles
                        if viewModel.targetHit {
                            ForEach(0..<8, id: \.self) { i in
                                Circle()
                                    .fill(themeManager.colors.accent3)
                                    .frame(width: gameAreaSize * 0.02, height: gameAreaSize * 0.02)
                                    .offset(
                                        x: cos(Double(i) * .pi / 4) * gameAreaSize * 0.1 * particleScale,
                                        y: sin(Double(i) * .pi / 4) * gameAreaSize * 0.1 * particleScale
                                    )
                                    .opacity(1.0 - particleScale)
                            }
                        }
                    }
                    .frame(height: gameAreaSize)
                    .onTapGesture {
                        viewModel.handleTap()
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                            particleScale = 2.0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            withAnimation(.easeOut(duration: 0.2)) {
                                particleScale = 1.0
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Bottom Stats
                    VStack(spacing: 12) {
                        HStack(spacing: 20) {
                            // Accuracy
                            VStack(spacing: 4) {
                                Text("ACCURACY")
                                    .font(.system(size: screenWidth * 0.025, weight: .bold, design: .rounded))
                                    .foregroundColor(themeManager.colors.textSecondary)
                                    .tracking(1.5)
                                
                                Text("\(Int(viewModel.accuracy))%")
                                    .font(.system(size: screenWidth * 0.08, weight: .bold, design: .rounded))
                                    .foregroundColor(themeManager.colors.accent4)
                                    .shadow(color: themeManager.colors.accent4.opacity(0.5), radius: 8, x: 0, y: 2)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(themeManager.colors.secondaryBackground.opacity(0.8))
                                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                            )
                            
                            // Hits
                            VStack(spacing: 4) {
                                Text("HITS")
                                    .font(.system(size: screenWidth * 0.025, weight: .bold, design: .rounded))
                                    .foregroundColor(themeManager.colors.textSecondary)
                                    .tracking(1.5)
                                
                                Text("\(viewModel.hits)/\(viewModel.totalTaps)")
                                    .font(.system(size: screenWidth * 0.08, weight: .bold, design: .rounded))
                                    .foregroundColor(themeManager.colors.accent3)
                                    .shadow(color: themeManager.colors.accent3.opacity(0.5), radius: 8, x: 0, y: 2)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(themeManager.colors.secondaryBackground.opacity(0.8))
                                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                            )
                        }
                        
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
        }
        .onAppear {
            viewModel.startGame()
        }
        .fullScreenCover(isPresented: $viewModel.showResults) {
            GameResultView(
                score: viewModel.score,
                accuracy: viewModel.accuracy,
                maxCombo: viewModel.combo,
                hits: viewModel.hits,
                totalTaps: viewModel.totalTaps,
                mode: .rhythm,
                onPlayAgain: {
                    viewModel.showResults = false
                    viewModel.resetGame()
                },
                onHome: {
                    dismiss()
                }
            )
        }
    }
}

