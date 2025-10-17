import Foundation
import SwiftUI

final class ModeSelectionViewModel: ObservableObject {
    @Published var showRhythmMode = false
    @Published var showEndlessMode = false
    @Published var showOrbitalMode = false
    
    func selectRhythmMode() {
        showRhythmMode = true
    }
    
    func selectEndlessMode() {
        showEndlessMode = true
    }
    
    func selectOrbitalMode() {
        showOrbitalMode = true
    }
}


