//
//  TasksError.swift
//  Tasks
//
//  Created by Rahul Serodia on 16/07/25.
//

import Foundation

enum TasksError: LocalizedError {
    case alreadyExists
    case fetchFailed
    case deleteFailed
    case notFound
    case saveFailed
    case notificationFailed
    case notificationPermissionDenied

    var errorDescription: String? {
        switch self {
        case .alreadyExists:
            return "A task with this title already exists."
        case .fetchFailed:
            return "Could not fetch tasks. Please try again."
        case .deleteFailed:
            return "Could not delete the task."
        case .saveFailed:
            return "Could not save your task. Please try again."
        case .notFound:
            return "Feedback not found."
        case .notificationFailed:
            return "Task notification setup failed. Please check your settings."
        case .notificationPermissionDenied:
            return "Notification permission denied. Please enable notifications in settings."
        }
    }
}
