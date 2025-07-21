//
//  TaskController.swift
//  Tasks
//
//  Created by Rahul Serodia on 14/07/25.
//

import Foundation

@MainActor
final class TaskController: ObservableObject {
    private let repository: TaskRepositoryProtocol
    private let notificationService: NotificationServiceProtocol
    
    @Published private(set) var allTasks: [TaskItem] = [] {
        didSet {
            buildTasksByDay()
        }
    }
    @Published var sortOption: SortOption = .dueDate
    @Published var filterOption: FilterOption = .all
    @Published var errorMessage: String?
    @Published var showErrorAlert = false
    private(set) var tasksByDay: [Date: [TaskItem]] = [:]
    
    var tasks: [TaskItem] {
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
    
    init(repository: TaskRepositoryProtocol, notificationService: NotificationServiceProtocol) {
        self.repository = repository
        self.notificationService = notificationService
    }
    
    // MARK: - CRUD operations
    func loadTasks() async {
        do {
            let tasks = try await repository.fetchTasks()
            self.allTasks = tasks
        } catch {
            await handle(error)
        }
    }
    
    func addTask(
        title: String,
        details: String,
        dueDate: Date,
        priority: Int,
        isCompleted: Bool = false,
        setReminder: Bool = false
    ) async {
        do {
            let task = TaskItem(title: title, details: details, isCompleted: isCompleted, dueDate: dueDate, priority: priority)
            try await repository.addTask(task)
            
            if setReminder {
                await handleNotification(for: task)
            }
            await loadTasks()
        } catch {
            await handle(error)
        }
    }
    
    func updateTask(
        _ task: TaskItem,
        title: String,
        details: String,
        dueDate: Date,
        priority: Int,
        isCompleted: Bool,
        setReminder: Bool = false
    ) async {
        do {
            task.title = title
            task.details = details
            task.dueDate = dueDate
            task.priority = priority
            task.isCompleted = isCompleted
            try await repository.updateTask(task)
            if (setReminder && !isCompleted) {
                await handleNotification(for: task)
            }
            await loadTasks()
        } catch {
            await handle(error)
        }
    }
    
    func delete(_ task: TaskItem) async {
        do {
            try await repository.deleteTask(task)
            await loadTasks()
        } catch {
            await handle(error)
        }
    }
    
    // MARK: - Calender operations
    private func buildTasksByDay() {
        tasksByDay = Dictionary(grouping: allTasks) { task in
            Calendar.current.startOfDay(for: task.dueDate)
        }
    }
    
    // MARK: - Notification Logic
    private func handleNotification(for task: TaskItem, shouldCancel: Bool = false) async {
        do {
            try await notificationService.scheduleNotification(
                title: "Reminder: \(task.title)",
                body: "Task is due at \(task.dueDate)",
                date: task.dueDate,
                id: task.id.uuidString
            )
        } catch {
            await handle(error)
        }
    }
    
    private func handle(_ error: Error) async {
        await MainActor.run {
            self.errorMessage = (error as? LocalizedError)?.errorDescription ?? "Something went wrong."
            self.showErrorAlert = true
        }
    }
}


// Remove later
#if DEBUG
extension TaskController {
    static var preview: TaskController {
        let controller = TaskController(repository: MockTaskRepository(), notificationService: NotificationService.shared)
        controller.allTasks = mockTask
        return controller
    }
    
    static let mockTask = [
        TaskItem(title: "Finish Assignment", details: "Complete all parts", isCompleted: false, dueDate: Date(), priority: 2),
        TaskItem(title: "Finish Assignment", details: "Complete all parts", isCompleted: false, dueDate: Date(), priority: 2),
        TaskItem(title: "Finish Assignment", details: "Complete all parts", isCompleted: false, dueDate: Date(), priority: 2),
        TaskItem(title: "Buy Groceries", details: "Milk, eggs, bread", isCompleted: true, dueDate: Date().addingTimeInterval(86400), priority: 1),
        TaskItem(title: "Buy Groceries", details: "Milk, eggs, bread", isCompleted: false, dueDate: Date().addingTimeInterval(86400), priority: 1),
        TaskItem(title: "Very Big", details: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", isCompleted: false, dueDate: Date().addingTimeInterval(-86400), priority: 3),
        
        TaskItem(title: "Very Big", details: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", isCompleted: false, dueDate: Date().addingTimeInterval(-86400), priority: 3),
        TaskItem(title: "Very Big", details: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", isCompleted: false, dueDate: Date().addingTimeInterval(-86400), priority: 3)
    ]
}

class MockTaskRepository: TaskRepositoryProtocol {
    func fetchTasks() -> [TaskItem] { [] }
    func addTask(_ task: TaskItem) {}
    func updateTask(_ task: TaskItem) {}
    func deleteTask(_ task: TaskItem) {}
}
#endif
