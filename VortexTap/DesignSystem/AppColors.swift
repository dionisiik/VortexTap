import SwiftUI

enum AppTheme: String, CaseIterable {
    case vortex = "Vortex"
    case pulse = "Pulse"
}

struct AppColors {
    static func colors(for theme: AppTheme) -> ThemeColors {
        switch theme {
        case .vortex:
            return VortexTheme()
        case .pulse:
            return PulseTheme()
        }
    }
}

protocol ThemeColors {
    var background: Color { get }
    var primaryBackground: Color { get }
    var secondaryBackground: Color { get }
    var accent1: Color { get }
    var accent2: Color { get }
    var accent3: Color { get }
    var accent4: Color { get }
    var accent5: Color { get }
    var textPrimary: Color { get }
    var textSecondary: Color { get }
}

struct VortexTheme: ThemeColors {
    let background = Color(hex: "#160b2b")
    let primaryBackground = Color(hex: "#8200ff")
    let secondaryBackground = Color(hex: "#271642")
    let accent1 = Color(hex: "#d2647f")
    let accent2 = Color(hex: "#5ce5d5")
    let accent3 = Color(hex: "#9bc98b")
    let accent4 = Color(hex: "#edbb88")
    let accent5 = Color(hex: "#ffe297")
    let textPrimary = Color.white
    let textSecondary = Color.white.opacity(0.7)
}

struct PulseTheme: ThemeColors {
    let background = Color(hex: "#0a0a1f")
    let primaryBackground = Color(hex: "#ff006e")
    let secondaryBackground = Color(hex: "#1a1a3e")
    let accent1 = Color(hex: "#fb5607")
    let accent2 = Color(hex: "#ffbe0b")
    let accent3 = Color(hex: "#8338ec")
    let accent4 = Color(hex: "#3a86ff")
    let accent5 = Color(hex: "#06ffa5")
    let textPrimary = Color.white
    let textSecondary = Color.white.opacity(0.7)
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let r, g, b: Double
        switch hex.count {
        case 6:
            r = Double((int >> 16) & 0xFF) / 255
            g = Double((int >> 8) & 0xFF) / 255
            b = Double(int & 0xFF) / 255
        default:
            r = 0
            g = 0
            b = 0
        }
        
        self.init(red: r, green: g, blue: b)
    }
}


