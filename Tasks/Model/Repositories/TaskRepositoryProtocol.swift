//
//  TaskRepositoryProtocol.swift
//  Tasks
//
//  Created by Rahul Serodia on 14/07/25.
//

@MainActor
protocol TaskRepositoryProtocol {
    func fetchTasks() async throws -> [TaskItem]
    func addTask(_ task: TaskItem) async throws
    func updateTask(_ task: TaskItem) async throws
    func deleteTask(_ task: TaskItem) async throws
}
