//
//   NotificationServiceProtocol.swift
//  Tasks
//
//  Created by Rahul Serodia on 18/07/25.
//

import Foundation

protocol NotificationServiceProtocol {
    func requestAuthorization() async throws
    func scheduleNotification(title: String, body: String, date: Date, id: String) async throws
    func cancelNotification(id: String) async
}
