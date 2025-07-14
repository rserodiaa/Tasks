//
//  TaskRepositoryProtocol.swift
//  Tasks
//
//  Created by Rahul Serodia on 14/07/25.
//

protocol TaskRepositoryProtocol {
    func fetchTasks(sortBy: SortOption, filter: FilterOption) -> [Task]
    func addTask(_ task: Task)
    func updateTask(_ task: Task)
    func deleteTask(_ task: Task)
}
