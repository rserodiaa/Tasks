//
//  RepositoryMock.swift
//  Tasks
//
//  Created by Rahul Serodia on 21/07/25.
//

import Foundation
@testable import Tasks

final class MockTaskRepository: TaskRepositoryProtocol {
    var tasks: [TaskItem] = []
    var shouldThrow = false

    func fetchTasks() async throws -> [TaskItem] {
        if shouldThrow { throw TasksError.fetchFailed }
        return tasks
    }

    func addTask(_ task: TaskItem) throws {
        if shouldThrow { throw TasksError.saveFailed }
        tasks.append(task)
    }

    func updateTask(_ task: TaskItem) throws {
        if shouldThrow { throw TasksError.saveFailed }
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        } else {
            throw TasksError.notFound
        }
    }

    func deleteTask(_ task: TaskItem) throws {
        if shouldThrow { throw TasksError.deleteFailed }
        tasks.removeAll { $0.id == task.id }
    }
}
