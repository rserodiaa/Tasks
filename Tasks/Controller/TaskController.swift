//
//  TaskController.swift
//  Tasks
//
//  Created by Rahul Serodia on 14/07/25.
//

import SwiftUI

class TaskController: ObservableObject {
    private let repository: TaskRepositoryProtocol
    private var fetchedTasks: [Task] = []
    @Published var tasks: [Task] = []
    @Published var sortOption: SortOption = .dueDate
    @Published var filterOption: FilterOption = .all

    init(repository: TaskRepositoryProtocol) {
        self.repository = repository
        fetchTasks()
    }

    // MARK: - Filter and Sort Options
    func filterTasks() {
        switch filterOption {
        case .all: tasks = fetchedTasks
        case .completed: tasks = fetchedTasks.filter { $0.isCompleted }
        case .incomplete: tasks = fetchedTasks.filter { !$0.isCompleted }
        }
    }
    
    func sortTasks() {
        switch sortOption {
        case .dueDate: tasks.sort { $0.dueDate < $1.dueDate }
        case .priority: tasks.sort { $0.priority < $1.priority }
        }
    }

    private func updateTasks() {
        filterTasks()
        sortTasks()
    }
    
    // MARK: - CRUD operations
    private func fetchTasks() {
        fetchedTasks = repository.fetchTasks()
        updateTasks()
    }

    func addTask(title: String, details: String, dueDate: Date, priority: Int, isCompleted: Bool = false) {
        let task = Task(title: title, details: details, isCompleted: isCompleted, dueDate: dueDate, priority: priority)
        repository.addTask(task)
        fetchTasks()
    }

    func updateTask(_ task: Task, title: String, details: String, dueDate: Date, priority: Int, isCompleted: Bool) {
        task.title = title
        task.details = details
        task.dueDate = dueDate
        task.priority = priority
        task.isCompleted = isCompleted
        repository.updateTask(task)
        fetchTasks()
    }

    func deleteTask(at offsets: IndexSet) {
        offsets.forEach { index in
            repository.deleteTask(tasks[index])
        }
        fetchTasks()
    }
    
    func delete(_ task: Task) {
        repository.deleteTask(task)
        fetchTasks()
    }
    
    // MARK: - Presentation Logic
    func formattedDueDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    func priorityDisplayValue(_ priority: Int) -> String {
        Priority(rawValue: priority)?.value ?? "Unknown"
    }
    
    func priorityColor(_ priority: Int) -> Color {
        Priority(rawValue: priority)?.color ?? .blue
    }
    
    func statusImage(for task: Task) -> (systemName: String, color: Color)? {
        if task.isCompleted {
            return (ImageConstants.checkmark, .green)
        } else if task.dueDate < Date() {
            return (ImageConstants.exclamation, .red)
        }
        return nil
    }
    
}
