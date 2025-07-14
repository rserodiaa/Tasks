//
//  TaskRepository.swift
//  Tasks
//
//  Created by Rahul Serodia on 14/07/25.
//

import SwiftData

enum SortOption { case dueDate, priority }
enum FilterOption { case all, completed, incomplete }

// TODO error handling, async await
class TaskRepository: TaskRepositoryProtocol {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchTasks(sortBy: SortOption = .dueDate, filter: FilterOption = .all) -> [Task] {
        var tasks = (try? context.fetch(FetchDescriptor<Task>())) ?? []
        
        // TODO pass filter to fetch from swift data
        switch filter {
        case .all:
            break
        case .completed:
            tasks = tasks.filter { $0.isCompleted }
        case .incomplete:
            tasks = tasks.filter { !$0.isCompleted }
        }
        switch sortBy {
        case .dueDate:
            tasks = tasks.sorted { $0.dueDate < $1.dueDate }
        case .priority:
            tasks = tasks.sorted { $0.priority < $1.priority }
        }
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
