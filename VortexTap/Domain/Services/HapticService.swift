import UIKit
import Combine

final class HapticService: ObservableObject {
    static let shared = HapticService()
    
    @Published var isHapticEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isHapticEnabled, forKey: "haptic_enabled")
        }
    }
    
    private let lightGenerator = UIImpactFeedbackGenerator(style: .light)
    private let mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let heavyGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private let notificationGenerator = UINotificationFeedbackGenerator()
    private let selectionGenerator = UISelectionFeedbackGenerator()
    
    private init() {
        self.isHapticEnabled = UserDefaults.standard.bool(forKey: "haptic_enabled")
        if !UserDefaults.standard.bool(forKey: "haptic_initialized") {
            self.isHapticEnabled = true
            UserDefaults.standard.set(true, forKey: "haptic_initialized")
        }
        
        lightGenerator.prepare()
        mediumGenerator.prepare()
        heavyGenerator.prepare()
        notificationGenerator.prepare()
        selectionGenerator.prepare()
    }
    
    func light() {
        guard isHapticEnabled else { return }
        lightGenerator.impactOccurred()
    }
    
    func medium() {
        guard isHapticEnabled else { return }
        mediumGenerator.impactOccurred()
    }
    
    func heavy() {
        guard isHapticEnabled else { return }
        heavyGenerator.impactOccurred()
    }
    
    func success() {
        guard isHapticEnabled else { return }
        notificationGenerator.notificationOccurred(.success)
    }
    
    func error() {
        guard isHapticEnabled else { return }
        notificationGenerator.notificationOccurred(.error)
    }
    
    func warning() {
        guard isHapticEnabled else { return }
        notificationGenerator.notificationOccurred(.warning)
    }
    
    func selection() {
        guard isHapticEnabled else { return }
        selectionGenerator.selectionChanged()
    }
    
    func toggleHaptic() {
        isHapticEnabled.toggle()
    }
}


