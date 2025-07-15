//
//  Enums.swift
//  Tasks
//
//  Created by Rahul Serodia on 15/07/25.
//

import SwiftUI

enum SortOption: String, CaseIterable, Identifiable {
    case dueDate = "Due Date"
    case priority = "Priority"
    var id: String { self.rawValue }
}

enum FilterOption: String, CaseIterable, Identifiable {
    case all = "All"
    case completed = "Completed"
    case incomplete = "Incomplete"
    var id: String { self.rawValue }
}
