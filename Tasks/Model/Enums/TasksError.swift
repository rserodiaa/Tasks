//
//  TasksError.swift
//  Tasks
//
//  Created by Rahul Serodia on 16/07/25.
//

import Foundation

enum TasksError: LocalizedError {
    case alreadyExists
    case deleteFailed
    case notFound
    case saveFailed

    var errorDescription: String? {
        switch self {
        case .alreadyExists:
            return "A task with this title already exists."
        case .deleteFailed:
            return "Could not delete the task."
        case .saveFailed:
            return "Could not save your task. Please try again."
        case .notFound:
            return "Feedback not found."
        }
    }
}
