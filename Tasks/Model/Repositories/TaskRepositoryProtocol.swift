//
//  TaskRepositoryProtocol.swift
//  Tasks
//
//  Created by Rahul Serodia on 14/07/25.
//

protocol TaskRepositoryProtocol {
    func fetchTasks() -> [Task]
    func addTask(_ task: Task)
    func updateTask(_ task: Task)
    func deleteTask(_ task: Task)
}
