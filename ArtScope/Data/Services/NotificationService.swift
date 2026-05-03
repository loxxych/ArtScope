//
//  NotificationService.swift
//  ArtScope
//
//  Created by loxxy on 03.05.2026.
//

import UserNotifications

final class NotificationService {
    
    static let shared = NotificationService()
    
    private init() {}
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error {
                print("Permission error:", error)
            }
        }
    }
    
    func scheduleDailyArtistNotification() {
        let center = UNUserNotificationCenter.current()
        
        center.removePendingNotificationRequests(
            withIdentifiers: ["artist_of_the_day_notification"]
        )
        
        let content = UNMutableNotificationContent()
        content.title = "🎨 Artist of the Day"
        content.body = "Check out today's featured artist!"
        content.sound = .default
        
        var components = DateComponents()
        components.hour = 12
        components.minute = 00
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: components,
            repeats: true
        )
        
        let request = UNNotificationRequest(
            identifier: "artist_of_the_day_notification",
            content: content,
            trigger: trigger
        )
        
        center.add(request)
    }
}
