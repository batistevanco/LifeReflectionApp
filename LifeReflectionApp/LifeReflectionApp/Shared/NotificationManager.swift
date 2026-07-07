//
//  NotificationManager.swift
//  LifeReflectionApp
//

import Foundation
import UserNotifications

enum NotificationManager {
    static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    /// Plant een notificatie op de open-datum van een brief.
    static func scheduleLetterNotification(openDate: Date) {
        requestPermission()

        let content = UNMutableNotificationContent()
        content.title = "Je hebt een brief van jezelf"
        content.body = "Een brief die je ooit schreef, mag vandaag geopend worden."
        content.sound = .default

        var components = Calendar.current.dateComponents([.year, .month, .day], from: openDate)
        components.hour = 9

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(
            identifier: "letter-\(openDate.timeIntervalSince1970)",
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(request)
    }

    /// Plant een wekelijkse reality check op de gekozen weekdag (1 = zondag ... 7 = zaterdag).
    static func scheduleWeeklyReview(weekday: Int = 1) {
        requestPermission()

        let content = UNMutableNotificationContent()
        content.title = "Je wekelijkse terugblik"
        content.body = "Je bent verder dan je denkt. Kijk even terug op je week."
        content.sound = .default

        var components = DateComponents()
        components.weekday = weekday
        components.hour = 18

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(
            identifier: "weekly-review",
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(request)
    }
}
