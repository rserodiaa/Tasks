//
//  TaskControllerTests.swift
//  Tasks
//
//  Created by Rahul Serodia on 21/07/25.
//

import XCTest
@testable import Tasks

@MainActor
final class TaskControllerTests: XCTestCase {
    var mockRepo: MockTaskRepository!
    var mockNotification: MockNotificationService!
    var controller: TaskController!
    var mockTasks = [TaskItem(title: "Finish Assignment", details: "Complete all parts", isCompleted: false, dueDate: Date(), priority: 2),
                     TaskItem(title: "Buy Groceries", details: "Milk, eggs, bread", isCompleted: true, dueDate: Date().addingTimeInterval(86400), priority: 1),
                     TaskItem(title: "Very Big", details: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", isCompleted: false, dueDate: Date().addingTimeInterval(-86400), priority: 3)
    ]
    
    override func setUp() {
        super.setUp()
        mockRepo = MockTaskRepository()
        mockRepo.tasks = mockTasks
        mockNotification = MockNotificationService()
        controller = TaskController(repository: mockRepo, notificationService: mockNotification)
    }
    
    // MARK: CRUD Tests
    func testLoadTasksSuccess() async {
        await controller.loadTasks()
        
        XCTAssertEqual(controller.allTasks.count, 3)
        XCTAssertEqual(controller.allTasks.first?.title, "Finish Assignment")
        // default priority check
        XCTAssertEqual(controller.tasks.first?.title, "Very Big")
    }
    
    func testLoadTasksFailure() async {
        mockRepo.shouldThrow = true
        
        await controller.loadTasks()
        
        XCTAssertTrue(controller.showErrorAlert)
        XCTAssertEqual(controller.errorMessage, TasksError.fetchFailed.localizedDescription)
    }
    
    func testAddTaskSuccess() async {
        await controller.addTask(title: "New", details: "Add", dueDate: .now, priority: 1)
        
        XCTAssertEqual(controller.allTasks.count, 4)
        XCTAssertEqual(mockRepo.tasks.count, 4)
    }
    
    func testAddTaskFailure() async {
        mockRepo.shouldThrow = true
        await controller.addTask(title: "New", details: "Add", dueDate: .now, priority: 1)
        
        XCTAssertEqual(mockRepo.tasks.count, 3)
        XCTAssertTrue(controller.showErrorAlert)
        XCTAssertEqual(controller.errorMessage, TasksError.saveFailed.localizedDescription)
    }
    
    
    func testAddTaskWithReminder() async {
        await controller.addTask(title: "Remind", details: "With Notification", dueDate: .now, priority: 1, setReminder: true)
        
        XCTAssertTrue(mockNotification.didScheduleNotification)
    }
    
    func testUpdateTaskSuccess() async {
        let task = mockTasks.first!
        task.details = "Updated Details"
        
        await controller.updateTask(task, title: "Finish Assignment", details: "Updated Details", dueDate: .now, priority: 2, isCompleted: false)
        
        XCTAssertFalse(controller.showErrorAlert)
    }
    
    func testUpdateTaskFailure() async {
        mockRepo.shouldThrow = true
        let task = TaskItem(title: "Update", details: "", isCompleted: false, dueDate: .now, priority: 1)
        
        await controller.updateTask(task, title: "Updated", details: "Changed", dueDate: .now, priority: 2, isCompleted: false)
        
        XCTAssertTrue(controller.showErrorAlert)
        XCTAssertEqual(controller.errorMessage, TasksError.saveFailed.localizedDescription)
    }
    
    func testUpdateTaskNotFound() async {
        let task = TaskItem(title: "Update", details: "", isCompleted: false, dueDate: .now, priority: 1)
        
        await controller.updateTask(task, title: "Updated", details: "Changed", dueDate: .now, priority: 2, isCompleted: false)
        
        XCTAssertTrue(controller.showErrorAlert)
        XCTAssertEqual(controller.errorMessage, TasksError.notFound.localizedDescription)
    }
    
    func testDeleteTaskSuccess() async {
        let task = mockTasks.last!
        
        await controller.delete(task)
        
        XCTAssertEqual(mockRepo.tasks.count, 2)
        XCTAssertEqual(controller.allTasks.count, 2)
        XCTAssertFalse(controller.allTasks.contains(where: { $0.title == task.title }))
    }
    
    func testDeleteTaskFailure() async {
        let task = mockTasks.last!
        mockRepo.shouldThrow = true
        
        await controller.delete(task)
        
        XCTAssertTrue(controller.showErrorAlert)
        XCTAssertEqual(controller.errorMessage, TasksError.deleteFailed.localizedDescription)
    }
    
    // MARK: - Testing sorting & filter
    func testSortTasksByDueDate() async {
        controller.sortOption = .dueDate
        
        await controller.loadTasks()
        
        XCTAssertEqual(controller.allTasks.count, 3)
        XCTAssertEqual(controller.tasks[0].title, "Very Big")
        XCTAssertEqual(controller.tasks[1].title, "Finish Assignment")
        XCTAssertEqual(controller.tasks[2].title, "Buy Groceries")
    }
    
    func testSortTasksByPriority() async {
        controller.sortOption = .priority
        
        await controller.loadTasks()
        
        XCTAssertEqual(controller.allTasks.count, 3)
        XCTAssertEqual(controller.tasks[0].title, "Buy Groceries")
        XCTAssertEqual(controller.tasks[1].title, "Finish Assignment")
        XCTAssertEqual(controller.tasks[2].title, "Very Big")
    }
    
    func testFilterTasks() async {
        controller.filterOption = .all
        
        await controller.loadTasks()
        
        XCTAssertEqual(controller.allTasks.count, 3)
        XCTAssertEqual(controller.tasks.count, 3)
        
        controller.filterOption = .completed
        XCTAssertEqual(controller.allTasks.count, 3)
        XCTAssertEqual(controller.tasks.count, 1)
        
        controller.filterOption = .incomplete
        XCTAssertEqual(controller.allTasks.count, 3)
        XCTAssertEqual(controller.tasks.count, 2)
    }
    
    // MARK: - priority value and color tests
    func testPriorityValues() async {
        let task = mockTasks.first!
        
        XCTAssertEqual(Priority(safeRawValue: task.priority).color, .orange)
        XCTAssertEqual(Priority(safeRawValue: task.priority).value, "Medium")
        
        let badPriorityTask = TaskItem(title: "Bad Priority", details: "", isCompleted: false, dueDate: .now, priority: 5)
        XCTAssertEqual(Priority(safeRawValue: badPriorityTask.priority).color, .blue)
        XCTAssertEqual(Priority(safeRawValue: badPriorityTask.priority).value, "Unknown")
    }
}
