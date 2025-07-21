//
//  MockNotificationService.swift
//  Tasks
//
//  Created by Rahul Serodia on 21/07/25.
//

import Foundation
@testable import Tasks

final class MockNotificationService: NotificationServiceProtocol {
    var didScheduleNotification = false
    var shouldThrow = false

    func requestAuthorization() async throws {
        if shouldThrow { throw TasksError.notificationPermissionDenied }
    }

    func scheduleNotification(title: String, body: String, date: Date, id: String) async throws {
        if shouldThrow { throw TasksError.notificationFailed }
        didScheduleNotification = true
    }

    func cancelNotification(id: String) async { }
}
