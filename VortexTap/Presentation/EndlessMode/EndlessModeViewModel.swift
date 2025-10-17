import Foundation
import Combine
import SwiftUI

final class EndlessModeViewModel: ObservableObject {
    @Published var rotation: Double = 0
    @Published var score: Int = 0
    @Published var combo: Int = 0
    @Published var lives: Int = 3
    @Published var currentSpeed: Double = 1.0
    @Published var targetHit: Bool = false
    @Published var gameEnded: Bool = false
    @Published var scoreMultiplier: Int = 1
    @Published var showMultiplier: Bool = false
    @Published var showResults: Bool = false
    
    private var timer: Timer?
    private let repository = GameRepository()
    private let soundService = SoundService.shared
    private var maxCombo: Int = 0
    private let targetZoneSize: Double = 25
    private var baseRotationSpeed: Double = 2.5
    
    var hits: Int = 0
    var totalTaps: Int = 0
    
    func startGame() {
        rotation = 0
        currentSpeed = 1.0
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            let speedMultiplier = min(1.0 + (Double(self.combo) / 100.0), 2.5)
            self.currentSpeed = speedMultiplier
            
            withAnimation(.linear(duration: 0.016)) {
                self.rotation += self.baseRotationSpeed * speedMultiplier
                if self.rotation >= 360 {
                    self.rotation -= 360
                }
            }
        }
    }
    
    func handleTap() {
        totalTaps += 1
        
        let normalizedRotation = rotation.truncatingRemainder(dividingBy: 360)
        
        // Target is at top (270 degrees or -90 degrees)
        // Check if rotation is near 270 degrees (accounting for wrap-around)
        let distanceToTarget = min(
            abs(normalizedRotation - 270),
            abs(normalizedRotation - 270 + 360),
            abs(normalizedRotation - 270 - 360)
        )
        
        if distanceToTarget <= targetZoneSize {
            hits += 1
            combo += 1
            
            scoreMultiplier = min(1 + combo / 10, 5)
            let earnedPoints = 10 * scoreMultiplier
            score += earnedPoints
            
            targetHit = true
            showMultiplier = true
            
            soundService.playSuccessSound()
            Haptics.shared.success()
            
            if combo > maxCombo {
                maxCombo = combo
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.targetHit = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.showMultiplier = false
            }
        } else {
            combo = 0
            scoreMultiplier = 1
            lives -= 1
            
            soundService.playMissSound()
            
            if lives == 1 {
                Haptics.shared.warning()
            } else if lives <= 0 {
                Haptics.shared.heavy()
                endGame()
            } else {
                Haptics.shared.error()
            }
        }
    }
    
    private func endGame() {
        timer?.invalidate()
        timer = nil
        gameEnded = true
        
        let accuracy = totalTaps > 0 ? (Double(hits) / Double(totalTaps)) * 100 : 0
        
        let gameScore = GameScore(
            score: score,
            accuracy: accuracy,
            maxCombo: maxCombo,
            mode: .endless
        )
        repository.saveScore(gameScore)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showResults = true
        }
    }
    
    func resetGame() {
        rotation = 0
        score = 0
        combo = 0
        lives = 3
        currentSpeed = 1.0
        targetHit = false
        gameEnded = false
        showResults = false
        scoreMultiplier = 1
        showMultiplier = false
        maxCombo = 0
        hits = 0
        totalTaps = 0
        startGame()
    }
    
    func getAccuracy() -> Double {
        return totalTaps > 0 ? (Double(hits) / Double(totalTaps)) * 100 : 0
    }
    
    deinit {
        timer?.invalidate()
    }
}

