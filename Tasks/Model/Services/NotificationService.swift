//
//  NotificationService.swift
//  Tasks
//
//  Created by Rahul Serodia on 18/07/25.
//

import Foundation
import UserNotifications

final class NotificationService: NotificationServiceProtocol {
    
    static let shared = NotificationService()
    private init() { }
        
    func requestAuthorization() async throws {
        let granted = try await UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge])
        
        if !granted {
            throw TasksError.notificationPermissionDenied
        }
    }
    
    func scheduleNotification(title: String, body: String, date: Date, id: String) async throws {
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default

            let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

            do {
                try await UNUserNotificationCenter.current().add(request)
                print("Notification scheduled for task id: \(id)")
            } catch {
                throw TasksError.notificationFailed
            }
        }

        func cancelNotification(id: String) async {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        }
}
