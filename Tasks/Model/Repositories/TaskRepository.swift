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

    func fetchTasks() -> [Task] {
        let tasks = (try? context.fetch(FetchDescriptor<Task>())) ?? []
        return tasks
    }

    func addTask(_ task: Task) {
        context.insert(task)
        try? context.save()
    }

    func updateTask(_ task: Task) {
        try? context.save()
    }

    func deleteTask(_ task: Task) {
        context.delete(task)
        try? context.save()
    }
}
