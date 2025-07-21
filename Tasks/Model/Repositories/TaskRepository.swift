//
//  TaskRepository.swift
//  Tasks
//
//  Created by Rahul Serodia on 14/07/25.
//

import SwiftData
import Foundation

final class TaskRepository: TaskRepositoryProtocol {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchTasks() async throws -> [TaskItem] {
        do {
            let tasks = try context.fetch(FetchDescriptor<TaskItem>())
            return tasks
        } catch {
            throw TasksError.fetchFailed
        }
    }

    func addTask(_ task: TaskItem) throws {
        do {
            context.insert(task)
            try context.save()
        } catch {
            throw TasksError.saveFailed
        }
        
    }

    func updateTask(_ task: TaskItem) throws {
        do {
            try validateTaskExists(with: task.id)
            try context.save()
        } catch let error as TasksError {
            throw error
        } catch {
            throw TasksError.saveFailed
        }
    }

    func deleteTask(_ task: TaskItem) throws {
        do {
            try validateTaskExists(with: task.id)
            context.delete(task)
            try context.save()
        } catch let error as TasksError {
            throw error
        } catch {
            throw TasksError.deleteFailed
        }
    }

    private func validateTaskExists(with id: UUID) throws {
        let descriptor = FetchDescriptor<TaskItem>(predicate: #Predicate { $0.id == id })
        guard let _ = try context.fetch(descriptor).first else {
            throw TasksError.notFound
        }
    }
}
