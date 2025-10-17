import Foundation
import UserNotifications
import Combine

final class NotificationService: ObservableObject {
    static let shared = NotificationService()
    
    @Published var isNotificationsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isNotificationsEnabled, forKey: "notifications_enabled")
            if isNotificationsEnabled {
                requestPermission()
            } else {
                removeAllPendingNotifications()
            }
        }
    }
    
    private init() {
        self.isNotificationsEnabled = UserDefaults.standard.bool(forKey: "notifications_enabled")
    }
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                if !granted {
                    self.isNotificationsEnabled = false
                }
            }
        }
    }
    
    func scheduleReminder() {
        guard isNotificationsEnabled else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Time to Play!"
        content.body = "Your rhythm awaits! Come back and improve your score."
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 19
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "daily_reminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func removeAllPendingNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func toggleNotifications() {
        isNotificationsEnabled.toggle()
    }
}


