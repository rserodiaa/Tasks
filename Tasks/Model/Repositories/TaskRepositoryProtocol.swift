//
//  TaskRepositoryProtocol.swift
//  Tasks
//
//  Created by Rahul Serodia on 14/07/25.
//

@MainActor
protocol TaskRepositoryProtocol {
    func fetchTasks() async -> [TaskItem]
    func addTask(_ task: TaskItem) async
    func updateTask(_ task: TaskItem) async
    func deleteTask(_ task: TaskItem) async
}
