//
//  TaskController.swift
//  Tasks
//
//  Created by Rahul Serodia on 14/07/25.
//

import Foundation

class TaskController: ObservableObject {
    private let repository: TaskRepositoryProtocol
    @Published var tasks: [Task] = []

    init(repository: TaskRepositoryProtocol) {
        self.repository = repository
        fetchTasks()
    }

    func fetchTasks() {
        tasks = repository.fetchTasks()
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

    func deleteTask(_ task: Task) {
        repository.deleteTask(task)
        fetchTasks()
    }
}
