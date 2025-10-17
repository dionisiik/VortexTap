import SwiftUI

struct OnboardingView: View {
    @Binding var isOnboardingComplete: Bool
    @State private var currentPage = 0
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        ZStack {
            themeManager.colors.background
                .ignoresSafeArea()
            
            VStack {
                TabView(selection: $currentPage) {
                    OnboardingPage1()
                        .tag(0)
                    
                    OnboardingPage2()
                        .tag(1)
                    
                    OnboardingPage3()
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? themeManager.colors.primaryBackground : themeManager.colors.textSecondary.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom, 20)
                
                if currentPage == 2 {
                    CustomButton(title: "Get Started") {
                        Haptics.shared.heavy()
                        isOnboardingComplete = true
                        UserDefaults.standard.set(true, forKey: "onboarding_complete")
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                } else {
                    Button(action: {
                        Haptics.shared.light()
                        withAnimation {
                            currentPage += 1
                        }
                    }) {
                        Text("Next")
                            .font(AppTypography.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(themeManager.colors.primaryBackground)
                            .cornerRadius(16)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

struct OnboardingPage1: View {
    @State private var rotation: Double = 0
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .stroke(themeManager.colors.accent1, lineWidth: 4)
                    .frame(width: 200, height: 200)
                
                Circle()
                    .stroke(themeManager.colors.accent2, lineWidth: 4)
                    .frame(width: 150, height: 150)
                
                Circle()
                    .stroke(themeManager.colors.accent3, lineWidth: 4)
                    .frame(width: 100, height: 100)
                
                Circle()
                    .fill(themeManager.colors.primaryBackground)
                    .frame(width: 20, height: 20)
                    .offset(x: 100)
                    .rotationEffect(.degrees(rotation))
            }
            .onAppear {
                withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
            
            VStack(spacing: 16) {
                Text("Welcome to VortexTap")
                    .font(AppTypography.title1)
                    .foregroundColor(themeManager.colors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text("Tap the circle when the moving point hits the target zone. Master the rhythm!")
                    .font(AppTypography.body)
                    .foregroundColor(themeManager.colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}

struct OnboardingPage2: View {
    @State private var scale: CGFloat = 1.0
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(themeManager.colors.accent4.opacity(0.3))
                    .frame(width: 200, height: 200)
                    .scaleEffect(scale)
                
                Circle()
                    .fill(themeManager.colors.accent5.opacity(0.5))
                    .frame(width: 150, height: 150)
                
                VStack(spacing: 8) {
                    Text("127")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(themeManager.colors.textPrimary)
                    
                    Text("COMBO")
                        .font(AppTypography.caption)
                        .foregroundColor(themeManager.colors.textSecondary)
                }
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    scale = 1.2
                }
            }
            
            VStack(spacing: 16) {
                Text("Build Your Combo")
                    .font(AppTypography.title1)
                    .foregroundColor(themeManager.colors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text("Chain perfect taps together to build massive combos and maximize your score!")
                    .font(AppTypography.body)
                    .foregroundColor(themeManager.colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}

struct OnboardingPage3: View {
    @State private var offset: CGFloat = -100
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(themeManager.colors.secondaryBackground)
                    .frame(width: 280, height: 180)
                
                VStack(spacing: 20) {
                    HStack(spacing: 20) {
                        VStack {
                            Text("🎵")
                                .font(.system(size: 40))
                            Text("Rhythm")
                                .font(AppTypography.caption)
                                .foregroundColor(themeManager.colors.textSecondary)
                        }
                        
                        VStack {
                            Text("♾️")
                                .font(.system(size: 40))
                            Text("Endless")
                                .font(AppTypography.caption)
                                .foregroundColor(themeManager.colors.textSecondary)
                        }
                    }
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(themeManager.colors.primaryBackground)
                        .frame(width: 200, height: 50)
                        .overlay(
                            Text("Start Playing")
                                .font(AppTypography.headline)
                                .foregroundColor(.white)
                        )
                }
                .offset(y: offset)
            }
            .onAppear {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.75)) {
                    offset = 0
                }
            }
            
            VStack(spacing: 16) {
                Text("Choose Your Mode")
                    .font(AppTypography.title1)
                    .foregroundColor(themeManager.colors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text("Play Rhythm Mode for structured levels or Endless Mode to test your limits!")
                    .font(AppTypography.body)
                    .foregroundColor(themeManager.colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}

