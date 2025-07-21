//
//  RepositoryTests.swift
//  Tasks
//
//  Created by Rahul Serodia on 21/07/25.
//

import XCTest
import SwiftData
@testable import Tasks

@MainActor
final class TaskRepositoryTests: XCTestCase {
    var modelContainer: ModelContainer!
    var repository: TaskRepository!
    
    override func setUp() async throws {
        modelContainer = try ModelContainer(for: TaskItem.self, configurations:
                                                ModelConfiguration(isStoredInMemoryOnly: true)
        )
        repository = TaskRepository(context: modelContainer.mainContext)
    }
    
    override func tearDown() async throws {
        modelContainer = nil
        repository = nil
    }
    
    func testFetchEmptyTasks() async throws {
        let tasks = try await repository.fetchTasks()
        XCTAssertTrue(tasks.isEmpty)
    }

    func testAddTask() async throws {
        let task = TaskItem(title: "Test", details: "Details", isCompleted: false, dueDate: .now, priority: 1)
        
        try repository.addTask(task)
        
        let tasks = try await repository.fetchTasks()
        XCTAssertEqual(tasks.count, 1)
        XCTAssertEqual(tasks.first?.title, "Test")
    }

    func testUpdateTask() async throws {
        let task = TaskItem(title: "Old", details: "Old", isCompleted: false, dueDate: .now, priority: 1)
        try repository.addTask(task)

        task.title = "Updated"
        try repository.updateTask(task)

        let tasks = try await repository.fetchTasks()
        XCTAssertEqual(tasks.first?.title, "Updated")
    }
    
    func testUpdateNonexistentTask() async throws {
        let missingTask = TaskItem(title: "Missing", details: "Doesn't exist", isCompleted: false, dueDate: .now, priority: 1)
        do {
            try repository.updateTask(missingTask)
            XCTFail("Expected updateTask to throw not Found error")
        } catch TasksError.notFound {
            // Pass
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }


    func testDeleteTask() async throws {
        let task = TaskItem(title: "ToDelete", details: "", isCompleted: false, dueDate: .now, priority: 0)
        try repository.addTask(task)

        try repository.deleteTask(task)

        let tasks = try await repository.fetchTasks()
        XCTAssertTrue(tasks.isEmpty)
    }

    func testDeleteNonexistentTask() async throws {
        let missingTask = TaskItem(title: "Missing", details: "Doesn't exist", isCompleted: false, dueDate: .now, priority: 1)
        do {
            try repository.deleteTask(missingTask)
            XCTFail("Expected deleteTask to throw not Found error")
        } catch TasksError.notFound {
            // Pass
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    
}
