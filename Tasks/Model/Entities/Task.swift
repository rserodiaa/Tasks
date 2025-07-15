//
//  Task.swift
//  Tasks
//
//  Created by Rahul Serodia on 14/07/25.
//

import SwiftData
import Foundation

@Model
class Task: Identifiable {
    var id: UUID = UUID()
    var title: String
    var details: String
    var isCompleted: Bool = false
    var dueDate: Date
    var priority: Int
    
    
    init(title: String, details: String, isCompleted: Bool, dueDate: Date, priority: Int) {
        self.title = title
        self.details = details
        self.isCompleted = isCompleted
        self.dueDate = dueDate
        self.priority = priority
    }
}
