//
//  TaskController.swift
//  Tasks
//
//  Created by Rahul Serodia on 14/07/25.
//

import Foundation

// TODO: CATCH, manually remove from allTasks
@MainActor
final class TaskController: ObservableObject {
    private let repository: TaskRepositoryProtocol
    private let notificationService: NotificationServiceProtocol
    lazy var service: NotificationServiceProtocol = {
        return NotificationService.shared
    }()

    @Published private(set) var allTasks: [TaskItem] = [] {
        didSet {
            buildTasksByDay()
        }
    }
    @Published var sortOption: SortOption = .dueDate
    @Published var filterOption: FilterOption = .all
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
        let tasks = await repository.fetchTasks()
        self.allTasks = tasks
    }

    func addTask(
        title: String,
        details: String,
        dueDate: Date,
        priority: Int,
        isCompleted: Bool = false,
        setReminder: Bool = false
    ) async {
        let task = TaskItem(title: title, details: details, isCompleted: isCompleted, dueDate: dueDate, priority: priority)
        await repository.addTask(task)
        
        if setReminder {
            await handleNotification(for: task)
        }
        await loadTasks()
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
        task.title = title
        task.details = details
        task.dueDate = dueDate
        task.priority = priority
        task.isCompleted = isCompleted
        await repository.updateTask(task)
        if (setReminder && !isCompleted) {
            await handleNotification(for: task)
        }
        
        await loadTasks()
    }

    func delete(_ task: TaskItem) async {
        await repository.deleteTask(task)
        await loadTasks()
    }
    
    // MARK: - Calender operations
    private func buildTasksByDay() {
        tasksByDay = Dictionary(grouping: allTasks) { task in
            Calendar.current.startOfDay(for: task.dueDate)
        }
    }
    
    // MARK: - Notification Logic
    func handleNotification(for task: TaskItem, shouldCancel: Bool = false) async {
        await notificationService.scheduleNotification(
            title: "Reminder: \(task.title)",
            body: "Task is due at \(task.dueDate)",
            date: task.dueDate,
            id: task.id.uuidString
        )
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
