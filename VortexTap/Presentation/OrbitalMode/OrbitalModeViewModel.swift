import Foundation
import Combine
import SwiftUI

final class OrbitalModeViewModel: ObservableObject {
    @Published var rotation: Double = 0
    @Published var score: Int = 0
    @Published var combo: Int = 0
    @Published var hits: Int = 0
    @Published var totalTaps: Int = 0
    @Published var accuracy: Double = 0
    @Published var targetHit: Bool = false
    @Published var gameEnded: Bool = false
    @Published var timeRemaining: Int = 45
    @Published var targetPosition: Double = 270
    @Published var targetOrbit: Int = 2
    @Published var pointOrbit: Int = 2
    @Published var showResults: Bool = false
    
    private var timer: Timer?
    private let repository = GameRepository()
    private let soundService = SoundService.shared
    private var maxCombo: Int = 0
    private let targetZoneSize: Double = 35
    private let rotationSpeed: Double = 3.5
    private let gameDuration: TimeInterval = 45
    private var startTime: Date?
    private let orbits: [Int] = [0, 1, 2, 3]
    
    func startGame() {
        startTime = Date()
        rotation = 0
        timeRemaining = Int(gameDuration)
        pointOrbit = 2
        generateNewTarget()
        
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
    
    private func generateNewTarget() {
        let positions: [Double] = [0, 45, 90, 135, 180, 225, 270, 315]
        let currentPosition = targetPosition
        let currentOrbit = targetOrbit
        
        var newPosition: Double
        var newOrbit: Int
        
        repeat {
            newPosition = positions.randomElement() ?? 270
            newOrbit = orbits.randomElement() ?? 2
        } while (newPosition == currentPosition && newOrbit == currentOrbit)
        
        withAnimation(.spring(response: 0.7, dampingFraction: 0.75)) {
            targetPosition = newPosition
            targetOrbit = newOrbit
        }
    }
    
    func handleTap() {
        totalTaps += 1
        
        if pointOrbit != targetOrbit {
            combo = 0
            soundService.playMissSound()
            Haptics.shared.error()
            updateAccuracy()
            return
        }
        
        let normalizedRotation = rotation.truncatingRemainder(dividingBy: 360)
        
        let distanceToTarget = min(
            abs(normalizedRotation - targetPosition),
            abs(normalizedRotation - targetPosition + 360),
            abs(normalizedRotation - targetPosition - 360)
        )
        
        if distanceToTarget <= targetZoneSize {
            hits += 1
            combo += 1
            score += 15 * combo
            targetHit = true
            
            soundService.playSuccessSound()
            Haptics.shared.success()
            
            if combo > maxCombo {
                maxCombo = combo
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                self.generateNewTarget()
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
    
    func switchOrbitUp() {
        guard pointOrbit < orbits.count - 1 else { return }
        withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
            pointOrbit += 1
        }
    }
    
    func switchOrbitDown() {
        guard pointOrbit > 0 else { return }
        withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
            pointOrbit -= 1
        }
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
            mode: .orbital
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
        pointOrbit = 2
        startGame()
    }
    
    deinit {
        timer?.invalidate()
    }
}

