import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        ZStack {
            themeManager.colors.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Title Label
                    Text("Settings")
                        .font(.system(size: 36, weight: .black, design: .rounded))
                        .foregroundColor(themeManager.colors.textPrimary)
                        .shadow(color: themeManager.colors.primaryBackground.opacity(0.5), radius: 12, x: 0, y: 4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Theme")
                                .font(AppTypography.title3)
                                .foregroundColor(themeManager.colors.textPrimary)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 12) {
                                ForEach(AppTheme.allCases, id: \.self) { theme in
                                    ThemeCard(
                                        theme: theme,
                                        isSelected: viewModel.selectedTheme == theme
                                    ) {
                                        viewModel.selectTheme(theme)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Audio & Feedback")
                                .font(AppTypography.title3)
                                .foregroundColor(themeManager.colors.textPrimary)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 12) {
                                SettingsToggleRow(
                                    icon: "speaker.wave.2.fill",
                                    title: "Sound",
                                    description: "Enable game sounds",
                                    isOn: $viewModel.soundEnabled,
                                    accentColor: themeManager.colors.accent1
                                ) {
                                    viewModel.toggleSound()
                                }
                                
                                SettingsToggleRow(
                                    icon: "waveform",
                                    title: "Haptic Feedback",
                                    description: "Enable vibration effects",
                                    isOn: $viewModel.hapticEnabled,
                                    accentColor: themeManager.colors.accent4
                                ) {
                                    viewModel.toggleHaptic()
                                }
                                
                                SettingsToggleRow(
                                    icon: "bell.fill",
                                    title: "Notifications",
                                    description: "Receive daily reminders",
                                    isOn: $viewModel.notificationsEnabled,
                                    accentColor: themeManager.colors.accent2
                                ) {
                                    viewModel.toggleNotifications()
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("About")
                                .font(AppTypography.title3)
                                .foregroundColor(themeManager.colors.textPrimary)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 0) {
                                SettingsInfoRow(title: "Version", value: "1.0.0")
                                
                                Divider()
                                    .background(themeManager.colors.textSecondary.opacity(0.2))
                                    .padding(.horizontal, 20)
                                
                                SettingsInfoRow(title: "Build", value: "1")
                            }
                            .background(themeManager.colors.secondaryBackground)
                            .cornerRadius(16)
                            .padding(.horizontal, 20)
                        }
                    }
                }
                .padding(.vertical, 20)
                .padding(.bottom, 90)
            }
        }
    }
}

struct ThemeCard: View {
    let theme: AppTheme
    let isSelected: Bool
    let action: () -> Void
    
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        Button(action: {
            Haptics.shared.medium()
            action()
        }) {
            HStack(spacing: 16) {
                HStack(spacing: 8) {
                    ForEach(themeColors, id: \.self) { color in
                        Circle()
                            .fill(color)
                            .frame(width: 24, height: 24)
                    }
                }
                
                Text(theme.rawValue)
                    .font(AppTypography.headline)
                    .foregroundColor(themeManager.colors.textPrimary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(themeManager.colors.accent3)
                        .font(.system(size: 24))
                }
            }
            .padding(20)
            .background(themeManager.colors.secondaryBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? themeManager.colors.accent3 : Color.clear, lineWidth: 2)
            )
            .cornerRadius(16)
        }
    }
    
    private var themeColors: [Color] {
        let colors = AppColors.colors(for: theme)
        return [colors.accent1, colors.accent2, colors.accent3]
    }
}

struct SettingsToggleRow: View {
    let icon: String
    let title: String
    let description: String
    @Binding var isOn: Bool
    let accentColor: Color
    let action: () -> Void
    
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(accentColor)
                .frame(width: 44, height: 44)
                .background(accentColor.opacity(0.2))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(AppTypography.headline)
                    .foregroundColor(themeManager.colors.textPrimary)
                
                Text(description)
                    .font(AppTypography.caption)
                    .foregroundColor(themeManager.colors.textSecondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(accentColor)
                .onChange(of: isOn) { _ in
                    Haptics.shared.light()
                    action()
                }
        }
        .padding(20)
        .background(themeManager.colors.secondaryBackground)
        .cornerRadius(16)
    }
}

struct SettingsInfoRow: View {
    let title: String
    let value: String
    
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        HStack {
            Text(title)
                .font(AppTypography.body)
                .foregroundColor(themeManager.colors.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(AppTypography.body)
                .foregroundColor(themeManager.colors.textPrimary)
        }
        .padding(20)
    }
}

