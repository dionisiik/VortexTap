import Foundation
import Combine
import SwiftUI

final class RhythmModeViewModel: ObservableObject {
    @Published var rotation: Double = 0
    @Published var score: Int = 0
    @Published var combo: Int = 0
    @Published var hits: Int = 0
    @Published var totalTaps: Int = 0
    @Published var accuracy: Double = 0
    @Published var targetHit: Bool = false
    @Published var gameEnded: Bool = false
    @Published var timeRemaining: Int = 60
    @Published var targetPosition: Double = 270
    @Published var showResults: Bool = false
    
    private var timer: Timer?
    private let repository = GameRepository()
    private let soundService = SoundService.shared
    private var maxCombo: Int = 0
    private let targetZoneSize: Double = 30
    private let rotationSpeed: Double = 3.0
    private let gameDuration: TimeInterval = 60
    private var startTime: Date?
    
    func startGame() {
        startTime = Date()
        rotation = 0
        timeRemaining = Int(gameDuration)
        generateNewTargetPosition()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            withAnimation(.linear(duration: 0.016)) {
                self.rotation += self.rotationSpeed
                if self.rotation >= 360 {
                    self.rotation -= 360
                }
            }
            
            if let startTime = self.startTime {
                let elapsed = Date().timeIntervalSince(startTime)
                let remaining = max(0, self.gameDuration - elapsed)
                let newTime = Int(ceil(remaining))
                
                if newTime == 10 && self.timeRemaining != 10 {
                    Haptics.shared.warning()
                } else if newTime == 5 && self.timeRemaining != 5 {
                    Haptics.shared.warning()
                } else if newTime == 3 && self.timeRemaining != 3 {
                    Haptics.shared.heavy()
                }
                
                self.timeRemaining = newTime
                
                if elapsed >= self.gameDuration {
                    self.endGame()
                }
            }
        }
    }
    
    private func generateNewTargetPosition() {
        let positions: [Double] = [0, 45, 90, 135, 180, 225, 270, 315]
        let currentPosition = targetPosition
        
        var newPosition: Double
        repeat {
            newPosition = positions.randomElement() ?? 270
        } while newPosition == currentPosition && positions.count > 1
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.75)) {
            targetPosition = newPosition
        }
    }
    
    func handleTap() {
        totalTaps += 1
        
        let normalizedRotation = rotation.truncatingRemainder(dividingBy: 360)
        
        // Check if rotation is near target position (accounting for wrap-around)
        let distanceToTarget = min(
            abs(normalizedRotation - targetPosition),
            abs(normalizedRotation - targetPosition + 360),
            abs(normalizedRotation - targetPosition - 360)
        )
        
        if distanceToTarget <= targetZoneSize {
            hits += 1
            combo += 1
            score += 10 * combo
            targetHit = true
            
            soundService.playSuccessSound()
            Haptics.shared.success()
            
            if combo > maxCombo {
                maxCombo = combo
            }
            
            // Generate new target position after successful hit
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                self.generateNewTargetPosition()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.targetHit = false
            }
        } else {
            combo = 0
            soundService.playMissSound()
            Haptics.shared.error()
        }
        
        updateAccuracy()
    }
    
    private func updateAccuracy() {
        if totalTaps > 0 {
            accuracy = (Double(hits) / Double(totalTaps)) * 100
        }
    }
    
    private func endGame() {
        timer?.invalidate()
        timer = nil
        gameEnded = true
        
        let gameScore = GameScore(
            score: score,
            accuracy: accuracy,
            maxCombo: maxCombo,
            mode: .rhythm
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
        hits = 0
        totalTaps = 0
        accuracy = 0
        targetHit = false
        gameEnded = false
        showResults = false
        maxCombo = 0
        startGame()
    }
    
    deinit {
        timer?.invalidate()
    }
}

