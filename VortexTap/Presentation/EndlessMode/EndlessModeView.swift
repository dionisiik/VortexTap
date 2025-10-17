import SwiftUI

struct EndlessModeView: View {
    @StateObject private var viewModel = EndlessModeViewModel()
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var themeManager = ThemeManager.shared
    @State private var pulseEffect: CGFloat = 1.0
    @State private var speedPulse: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            themeManager.colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                EndlessModeTopBar(
                    score: viewModel.score,
                    lives: viewModel.lives,
                    pulseEffect: pulseEffect,
                    onDismiss: { dismiss() }
                )
                
                Spacer()
                
                EndlessModeGameArea(
                    rotation: viewModel.rotation,
                    targetHit: viewModel.targetHit,
                    showMultiplier: viewModel.showMultiplier,
                    scoreMultiplier: viewModel.scoreMultiplier,
                    pulseEffect: pulseEffect,
                    onTap: {
                        viewModel.handleTap()
                        withAnimation(.easeInOut(duration: 0.3)) {
                            pulseEffect = 1.2
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                pulseEffect = 1.0
                            }
                        }
                    }
                )
                
                Spacer()
                
                EndlessModeBottomStats(
                    combo: viewModel.combo,
                    currentSpeed: viewModel.currentSpeed,
                    speedPulse: speedPulse
                )
            }
        }
        .onAppear {
            viewModel.startGame()
            withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                pulseEffect = 1.1
                speedPulse = 1.1
            }
        }
        .fullScreenCover(isPresented: $viewModel.showResults) {
            GameResultView(
                score: viewModel.score,
                accuracy: viewModel.getAccuracy(),
                maxCombo: viewModel.combo,
                hits: viewModel.hits,
                totalTaps: viewModel.totalTaps,
                mode: .endless,
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

struct EndlessModeTopBar: View {
    let score: Int
    let lives: Int
    let pulseEffect: CGFloat
    let onDismiss: () -> Void
    
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            
            HStack {
                Button(action: {
                    Haptics.shared.medium()
                    onDismiss()
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
                
                VStack(spacing: 2) {
                    Text("SCORE")
                        .font(.system(size: screenWidth * 0.025, weight: .bold, design: .rounded))
                        .foregroundColor(themeManager.colors.textSecondary)
                        .tracking(2)
                    
                    Text("\(score)")
                        .font(.system(size: screenWidth * 0.07, weight: .bold, design: .rounded))
                        .foregroundColor(themeManager.colors.accent5)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(themeManager.colors.secondaryBackground.opacity(0.8))
                )
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text("LIVES")
                        .font(.system(size: screenWidth * 0.025, weight: .bold, design: .rounded))
                        .foregroundColor(themeManager.colors.textSecondary)
                        .tracking(2)
                    
                    HStack(spacing: 6) {
                        ForEach(0..<lives, id: \.self) { _ in
                            Image(systemName: "heart.fill")
                                .font(.system(size: screenWidth * 0.03))
                                .foregroundColor(themeManager.colors.accent1)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(themeManager.colors.secondaryBackground.opacity(0.8))
                )
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 8)
        }
        .frame(height: 100)
    }
}

struct EndlessModeGameArea: View {
    let rotation: Double
    let targetHit: Bool
    let showMultiplier: Bool
    let scoreMultiplier: Int
    let pulseEffect: CGFloat
    let onTap: () -> Void
    
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        GeometryReader { geometry in
            let gameSize = min(geometry.size.width, geometry.size.height) * 0.95
            let orbitRadius = gameSize * 0.3
            let targetSize = gameSize * 0.17
            let movingPointSize = gameSize * 0.075
            let centerSize = gameSize * 0.17
            
            ZStack {
                ForEach(0..<5, id: \.self) { index in
                    Circle()
                        .stroke(themeManager.colors.accent1.opacity(0.3), lineWidth: 2.5)
                        .frame(
                            width: gameSize * (0.26 + CGFloat(index) * 0.11),
                            height: gameSize * (0.26 + CGFloat(index) * 0.11)
                        )
                }
                
                ZStack {
                    Circle()
                        .fill(themeManager.colors.accent5.opacity(0.4))
                        .frame(width: targetSize, height: targetSize)
                    
                    Image(systemName: "target")
                        .font(.system(size: targetSize * 0.43, weight: .bold))
                        .foregroundColor(themeManager.colors.accent5)
                }
                .offset(x: 0, y: -orbitRadius)
                
                ZStack {
                    ForEach(0..<5, id: \.self) { i in
                        Circle()
                            .fill(targetHit ? themeManager.colors.accent3.opacity(0.4) : themeManager.colors.primaryBackground.opacity(0.4))
                            .frame(width: movingPointSize * (1.0 - CGFloat(i) * 0.17), height: movingPointSize * (1.0 - CGFloat(i) * 0.17))
                            .offset(
                                x: cos((rotation - Double(i * 12)) * .pi / 180) * orbitRadius,
                                y: sin((rotation - Double(i * 12)) * .pi / 180) * orbitRadius
                            )
                    }
                    
                    Circle()
                        .fill(targetHit ? themeManager.colors.accent3 : themeManager.colors.primaryBackground)
                        .frame(width: movingPointSize, height: movingPointSize)
                        .overlay(Circle().stroke(Color.white, lineWidth: 3))
                        .offset(
                            x: cos(rotation * .pi / 180) * orbitRadius,
                            y: sin(rotation * .pi / 180) * orbitRadius
                        )
                        .scaleEffect(targetHit ? 1.4 : 1.0)
                }
                
                ZStack {
                    Circle()
                        .fill(themeManager.colors.accent1)
                        .frame(width: centerSize, height: centerSize)
                    
                    if showMultiplier {
                        Text("x\(scoreMultiplier)")
                            .font(.system(size: centerSize * 0.46, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                    } else {
                        Image(systemName: "infinity")
                            .font(.system(size: centerSize * 0.43, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .onTapGesture {
                onTap()
            }
        }
        .aspectRatio(1.0, contentMode: .fit)
    }
}

struct EndlessModeBottomStats: View {
    let combo: Int
    let currentSpeed: Double
    let speedPulse: CGFloat
    
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            
            HStack(spacing: 16) {
                VStack(spacing: 6) {
                    Text("COMBO")
                        .font(.system(size: screenWidth * 0.028, weight: .bold, design: .rounded))
                        .foregroundColor(themeManager.colors.textSecondary)
                        .tracking(2)
                    
                    Text("\(combo)")
                        .font(.system(size: screenWidth * 0.1, weight: .black, design: .rounded))
                        .foregroundColor(themeManager.colors.accent1)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(themeManager.colors.secondaryBackground.opacity(0.8))
                )
                
                VStack(spacing: 6) {
                    Text("SPEED")
                        .font(.system(size: screenWidth * 0.028, weight: .bold, design: .rounded))
                        .foregroundColor(themeManager.colors.textSecondary)
                        .tracking(2)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "bolt.fill")
                            .font(.system(size: screenWidth * 0.05))
                            .foregroundColor(themeManager.colors.accent2)
                        
                        Text(String(format: "%.1f", currentSpeed))
                            .font(.system(size: screenWidth * 0.1, weight: .black, design: .rounded))
                            .foregroundColor(themeManager.colors.accent2)
                    }
                    .scaleEffect(speedPulse)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(themeManager.colors.secondaryBackground.opacity(0.8))
                )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .frame(height: 120)
    }
}
