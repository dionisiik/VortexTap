import AVFoundation
import Combine

final class SoundService: ObservableObject {
    static let shared = SoundService()
    
    @Published var isSoundEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isSoundEnabled, forKey: "sound_enabled")
        }
    }
    
    private var audioPlayer: AVAudioPlayer?
    
    private init() {
        self.isSoundEnabled = UserDefaults.standard.bool(forKey: "sound_enabled")
        if !UserDefaults.standard.bool(forKey: "sound_initialized") {
            self.isSoundEnabled = true
            UserDefaults.standard.set(true, forKey: "sound_initialized")
        }
    }
    
    func playTapSound() {
        guard isSoundEnabled else { return }
    }
    
    func playSuccessSound() {
        guard isSoundEnabled else { return }
    }
    
    func playMissSound() {
        guard isSoundEnabled else { return }
    }
    
    func toggleSound() {
        isSoundEnabled.toggle()
    }
}


