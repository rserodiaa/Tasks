//
//  TaskRepository.swift
//  Tasks
//
//  Created by Rahul Serodia on 14/07/25.
//

import SwiftData

enum SortOption: String, CaseIterable, Identifiable {
    case dueDate = "Due Date"
    case priority = "Priority"
    var id: String { self.rawValue }
}
enum FilterOption: String, CaseIterable, Identifiable {
    case all = "All"
    case completed = "Completed"
    case incomplete = "Incomplete"
    var id: String { self.rawValue }
}

enum Priority: Int, CaseIterable, Identifiable {
    case high = 1
    case medium
    case low
    var id: Int { self.rawValue }
    var value: String {
        switch self {
        case .high: return "High"
        case .medium: return "Medium"
        case .low: return "Low"
        }
    }
}

// TODO error handling, async await
class TaskRepository: TaskRepositoryProtocol {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchTasks(sortBy: SortOption, filter: FilterOption) -> [Task] {
        var tasks = (try? context.fetch(FetchDescriptor<Task>())) ?? []
        
        // TODO move to controller
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
