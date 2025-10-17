import SwiftUI

struct CustomNavigationBar: View {
    let title: String
    let showBackButton: Bool
    let onBackTap: (() -> Void)?
    
    @ObservedObject private var themeManager = ThemeManager.shared
    
    init(title: String, showBackButton: Bool = false, onBackTap: (() -> Void)? = nil) {
        self.title = title
        self.showBackButton = showBackButton
        self.onBackTap = onBackTap
    }
    
    var body: some View {
        HStack {
            if showBackButton {
                Button(action: {
                    onBackTap?()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(themeManager.colors.textPrimary)
                        .frame(width: 44, height: 44)
                }
            }
            
            Text(title)
                .font(AppTypography.title2)
                .foregroundColor(themeManager.colors.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(themeManager.colors.secondaryBackground.opacity(0.8))
    }
}


