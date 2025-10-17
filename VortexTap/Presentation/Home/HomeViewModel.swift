import Foundation
import SwiftUI

final class HomeViewModel: ObservableObject {
    @Published var showModeSelection = false
    
    func navigateToModeSelection() {
        showModeSelection = true
    }
}

