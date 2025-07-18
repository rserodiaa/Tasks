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
    private let notificationService: NotificationServiceProtocol

    @Published private(set) var allTasks: [Task] = [] {
        didSet {
            buildTasksByDay()
        }
    }
    @Published var sortOption: SortOption = .dueDate
    @Published var filterOption: FilterOption = .all
    private(set) var tasksByDay: [Date: [Task]] = [:]


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
    
    init(repository: TaskRepositoryProtocol, notificationService: NotificationServiceProtocol) {
        self.repository = repository
        self.notificationService = notificationService
        //TODO: call from view, controller should not fetch tasks on its own
        fetchTasks()
    }
    
    // MARK: - CRUD operations
    private func fetchTasks() {
        allTasks = repository.fetchTasks()
    }

    func addTask(
        title: String,
        details: String,
        dueDate: Date,
        priority: Int,
        isCompleted: Bool = false,
        setReminder: Bool = false
    ) {
        let task = Task(title: title, details: details, isCompleted: isCompleted, dueDate: dueDate, priority: priority)
        repository.addTask(task)
        handleNotification(for: task, shouldSchedule: setReminder)
        fetchTasks()
    }
    
    func updateTask(
        _ task: Task,
        title: String,
        details: String,
        dueDate: Date,
        priority: Int,
        isCompleted: Bool,
        setReminder: Bool = false
    ) {
        task.title = title
        task.details = details
        task.dueDate = dueDate
        task.priority = priority
        task.isCompleted = isCompleted
        repository.updateTask(task)
        await handleNotification(for: task, shouldSchedule: setReminder && !isCompleted)
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
    
    // MARK: - Calender operations
    private func buildTasksByDay() {
        tasksByDay = Dictionary(grouping: allTasks) { task in
            Calendar.current.startOfDay(for: task.dueDate)
        }
    }
    
    // MARK: - Notification Logic
    func handleNotification(for task: Task, shouldSchedule: Bool) async {
            if shouldSchedule {
                await notificationService.scheduleNotification(
                    title: "Reminder: \(task.title)",
                    body: "Task is due at \(task.dueDate)",
                    date: task.dueDate,
                    id: task.id.uuidString
                )
            } else {
                await notificationService.cancelNotification(id: task.id.uuidString)
            }
    }
}

// Remove later
#if DEBUG
extension TaskController {
    static var preview: TaskController {
        let controller = TaskController(repository: MockTaskRepository())
        controller.allTasks = mockTask
        return controller
    }
    
    static let mockTask = [
        Task(title: "Finish Assignment", details: "Complete all parts", isCompleted: false, dueDate: Date(), priority: 2),
        Task(title: "Finish Assignment", details: "Complete all parts", isCompleted: false, dueDate: Date(), priority: 2),
        Task(title: "Finish Assignment", details: "Complete all parts", isCompleted: false, dueDate: Date(), priority: 2),
        Task(title: "Buy Groceries", details: "Milk, eggs, bread", isCompleted: true, dueDate: Date().addingTimeInterval(86400), priority: 1),
        Task(title: "Buy Groceries", details: "Milk, eggs, bread", isCompleted: false, dueDate: Date().addingTimeInterval(86400), priority: 1),
        Task(title: "Very Big", details: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", isCompleted: false, dueDate: Date().addingTimeInterval(-86400), priority: 3)
    ]
}

class MockTaskRepository: TaskRepositoryProtocol {
    func fetchTasks() -> [Task] { [] }
    func addTask(_ task: Task) {}
    func updateTask(_ task: Task) {}
    func deleteTask(_ task: Task) {}
}
#endif
