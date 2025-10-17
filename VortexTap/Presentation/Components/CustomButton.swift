import SwiftUI

struct CustomButton: View {
    let title: String
    let action: () -> Void
    var backgroundColor: Color?
    var isDisabled: Bool = false
    
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        Button(action: {
            Haptics.shared.light()
            action()
        }) {
            Text(title)
                .font(AppTypography.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    backgroundColor ?? themeManager.colors.primaryBackground
                )
                .opacity(isDisabled ? 0.5 : 1.0)
                .cornerRadius(16)
        }
        .disabled(isDisabled)
    }
}


