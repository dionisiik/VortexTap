import SwiftUI

struct OrbitalModeView: View {
    @StateObject private var viewModel = OrbitalModeViewModel()
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        ZStack {
            themeManager.colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                OrbitalModeTopBar(
                    score: viewModel.score,
                    combo: viewModel.combo,
                    timeRemaining: viewModel.timeRemaining,
                    onDismiss: { dismiss() }
                )
                
                Spacer()
                
                OrbitalModeGameArea(
                    rotation: viewModel.rotation,
                    targetPosition: viewModel.targetPosition,
                    targetOrbit: viewModel.targetOrbit,
                    pointOrbit: viewModel.pointOrbit,
                    targetHit: viewModel.targetHit,
                    onTap: { viewModel.handleTap() }
                )
                
                Spacer()
                
                OrbitalModeControls(
                    currentOrbit: viewModel.pointOrbit,
                    onOrbitUp: { viewModel.switchOrbitUp() },
                    onOrbitDown: { viewModel.switchOrbitDown() }
                )
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
                mode: .orbital,
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

struct OrbitalModeTopBar: View {
    let score: Int
    let combo: Int
    let timeRemaining: Int
    let onDismiss: () -> Void
    
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let timerSize = min(screenWidth, geometry.size.height) * 0.12
            
            VStack(spacing: 12) {
                // Timer Circle
                ZStack {
                    Circle()
                        .stroke(themeManager.colors.textSecondary.opacity(0.2), lineWidth: 6)
                        .frame(width: timerSize, height: timerSize)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(timeRemaining) / 45.0)
                        .stroke(
                            LinearGradient(
                                colors: timeRemaining > 10
                                    ? [themeManager.colors.accent3, themeManager.colors.accent2]
                                    : [themeManager.colors.accent1, themeManager.colors.accent4],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: timerSize, height: timerSize)
                        .rotationEffect(.degrees(-90))
                    
                    VStack(spacing: 2) {
                        Text("\(timeRemaining)")
                            .font(.system(size: timerSize * 0.35, weight: .black, design: .rounded))
                            .foregroundColor(themeManager.colors.textPrimary)
                        
                        Text("SEC")
                            .font(.system(size: timerSize * 0.11, weight: .bold, design: .rounded))
                            .foregroundColor(themeManager.colors.textSecondary)
                            .tracking(1)
                    }
                }
                
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
                            .font(.system(size: screenWidth * 0.055, weight: .bold, design: .rounded))
                            .foregroundColor(themeManager.colors.accent5)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(RoundedRectangle(cornerRadius: 12).fill(themeManager.colors.secondaryBackground.opacity(0.8)))
                    
                    Spacer()
                    
                    VStack(spacing: 2) {
                        Text("COMBO")
                            .font(.system(size: screenWidth * 0.025, weight: .bold, design: .rounded))
                            .foregroundColor(themeManager.colors.textSecondary)
                            .tracking(2)
                        
                        Text("\(combo)")
                            .font(.system(size: screenWidth * 0.055, weight: .bold, design: .rounded))
                            .foregroundColor(themeManager.colors.accent1)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(RoundedRectangle(cornerRadius: 12).fill(themeManager.colors.secondaryBackground.opacity(0.8)))
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 8)
        }
        .frame(height: 180)
    }
}

struct OrbitalModeGameArea: View {
    let rotation: Double
    let targetPosition: Double
    let targetOrbit: Int
    let pointOrbit: Int
    let targetHit: Bool
    let onTap: () -> Void
    
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        GeometryReader { geometry in
            let gameSize = min(geometry.size.width, geometry.size.height) * 0.95
            let orbitRadii: [CGFloat] = [
                gameSize * 0.2,
                gameSize * 0.275,
                gameSize * 0.35,
                gameSize * 0.425
            ]
            let targetSize = gameSize * 0.15
            let movingPointSize = gameSize * 0.07
            let centerSize = gameSize * 0.1
            
            ZStack {
                ForEach(0..<4, id: \.self) { index in
                    Circle()
                        .stroke(
                            index == pointOrbit || index == targetOrbit
                                ? themeManager.colors.primaryBackground.opacity(0.4)
                                : themeManager.colors.textSecondary.opacity(0.15),
                            lineWidth: index == pointOrbit || index == targetOrbit ? 3 : 2
                        )
                        .frame(width: orbitRadii[index] * 2, height: orbitRadii[index] * 2)
                }
                
                ZStack {
                    Circle()
                        .fill(themeManager.colors.accent2.opacity(0.5))
                        .frame(width: targetSize, height: targetSize)
                    
                    Image(systemName: "target")
                        .font(.system(size: targetSize * 0.42, weight: .bold))
                        .foregroundColor(themeManager.colors.accent2)
                }
                .offset(
                    x: cos(targetPosition * .pi / 180) * orbitRadii[targetOrbit],
                    y: sin(targetPosition * .pi / 180) * orbitRadii[targetOrbit]
                )
                
                ZStack {
                    ForEach(0..<3, id: \.self) { i in
                        Circle()
                            .fill(targetHit ? themeManager.colors.accent3.opacity(0.3) : themeManager.colors.primaryBackground.opacity(0.3))
                            .frame(width: movingPointSize * (1.0 - CGFloat(i) * 0.2), height: movingPointSize * (1.0 - CGFloat(i) * 0.2))
                            .offset(
                                x: cos((rotation - Double(i * 10)) * .pi / 180) * orbitRadii[pointOrbit],
                                y: sin((rotation - Double(i * 10)) * .pi / 180) * orbitRadii[pointOrbit]
                            )
                    }
                    
                    Circle()
                        .fill(targetHit ? themeManager.colors.accent3 : themeManager.colors.primaryBackground)
                        .frame(width: movingPointSize, height: movingPointSize)
                        .overlay(Circle().stroke(Color.white.opacity(0.8), lineWidth: 2))
                        .offset(
                            x: cos(rotation * .pi / 180) * orbitRadii[pointOrbit],
                            y: sin(rotation * .pi / 180) * orbitRadii[pointOrbit]
                        )
                        .scaleEffect(targetHit ? 1.3 : 1.0)
                }
                
                Circle()
                    .fill(themeManager.colors.accent1)
                    .frame(width: centerSize, height: centerSize)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onTapGesture {
                onTap()
            }
        }
        .aspectRatio(1.0, contentMode: .fit)
    }
}

struct OrbitalModeControls: View {
    let currentOrbit: Int
    let onOrbitUp: () -> Void
    let onOrbitDown: () -> Void
    
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            
            VStack(spacing: 16) {
                HStack(spacing: 20) {
                    Text("CURRENT ORBIT: \(currentOrbit + 1)")
                        .font(.system(size: screenWidth * 0.035, weight: .bold, design: .rounded))
                        .foregroundColor(themeManager.colors.textSecondary)
                        .tracking(1.5)
                }
                
                HStack(spacing: 20) {
                    Button(action: {
                        Haptics.shared.medium()
                        onOrbitDown()
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: "arrow.down.circle.fill")
                                .font(.system(size: screenWidth * 0.1))
                                .foregroundColor(currentOrbit > 0 ? themeManager.colors.accent4 : themeManager.colors.textSecondary.opacity(0.3))
                            
                            Text("INNER")
                                .font(.system(size: screenWidth * 0.03, weight: .bold, design: .rounded))
                                .foregroundColor(themeManager.colors.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(themeManager.colors.secondaryBackground)
                                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                        )
                    }
                    .disabled(currentOrbit == 0)
                    .buttonStyle(ScaleButtonStyle())
                    
                    Button(action: {
                        Haptics.shared.medium()
                        onOrbitUp()
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: screenWidth * 0.1))
                                .foregroundColor(currentOrbit < 3 ? themeManager.colors.accent3 : themeManager.colors.textSecondary.opacity(0.3))
                            
                            Text("OUTER")
                                .font(.system(size: screenWidth * 0.03, weight: .bold, design: .rounded))
                                .foregroundColor(themeManager.colors.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(themeManager.colors.secondaryBackground)
                                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                        )
                    }
                    .disabled(currentOrbit == 3)
                    .buttonStyle(ScaleButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .frame(height: 140)
    }
}

