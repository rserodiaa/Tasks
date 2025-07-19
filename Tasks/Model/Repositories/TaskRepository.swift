//
//  TaskRepository.swift
//  Tasks
//
//  Created by Rahul Serodia on 14/07/25.
//

import SwiftData

// TODO error handling, async await
class TaskRepository: TaskRepositoryProtocol {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchTasks() async -> [TaskItem] {
        let tasks = (try? context.fetch(FetchDescriptor<TaskItem>())) ?? []
        return tasks
    }

    func addTask(_ task: TaskItem) {
        context.insert(task)
        try? context.save()
    }

    func updateTask(_ task: TaskItem) {
        try? context.save()
    }

    func deleteTask(_ task: TaskItem) {
        context.delete(task)
        try? context.save()
    }
}
