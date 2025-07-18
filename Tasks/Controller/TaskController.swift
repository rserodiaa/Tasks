//
//  TaskController.swift
//  Tasks
//
//  Created by Rahul Serodia on 14/07/25.
//

import Foundation

//TODO: USE ASYNC AWAIT
class TaskController: ObservableObject {
    private let repository: TaskRepositoryProtocol
    @Published private(set) var allTasks: [Task] = []
    @Published var sortOption: SortOption = .dueDate
    @Published var filterOption: FilterOption = .all

    var tasks: [Task] {
        var result = allTasks

        switch filterOption {
        case .all: break
        case .completed: result = result.filter { $0.isCompleted }
        case .incomplete: result = result.filter { !$0.isCompleted }
        }

        switch sortOption {
        case .dueDate: result.sort { $0.dueDate < $1.dueDate }
        case .priority: result.sort { $0.priority < $1.priority }
        }
        return result
    }
    
    init(repository: TaskRepositoryProtocol) {
        self.repository = repository
        //TODO: call from view, controller should not fetch tasks on its own
        fetchTasks()
    }
    
    // MARK: - CRUD operations
    private func fetchTasks() {
        allTasks = repository.fetchTasks()
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
}

// Remove later
#if DEBUG
extension TaskController {
    static var preview: TaskController {
        let controller = TaskController(repository: MockTaskRepository())
        // Populate with sample tasks
        let tasks = [
            Task(title: "Finish Assignment", details: "Complete all parts", isCompleted: false, dueDate: Date(), priority: 2),
            Task(title: "Buy Groceries", details: "Milk, eggs, bread", isCompleted: true, dueDate: Date().addingTimeInterval(86400), priority: 1),
            Task(title: "Buy Groceries", details: "Milk, eggs, bread", isCompleted: false, dueDate: Date().addingTimeInterval(86400), priority: 1),
            Task(title: "Very Big", details: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", isCompleted: false, dueDate: Date().addingTimeInterval(-86400), priority: 3)
        ]
        controller.allTasks = tasks
        return controller
    }
}

class MockTaskRepository: TaskRepositoryProtocol {
    func fetchTasks() -> [Task] { [] }
    func addTask(_ task: Task) {}
    func updateTask(_ task: Task) {}
    func deleteTask(_ task: Task) {}
}
#endif
