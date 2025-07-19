//
//  CalendarDateListView.swift
//  Tasks
//
//  Created by Rahul Serodia on 18/07/25.
//

import SwiftUI

struct CalendarDateListView: View {
    let tasks: [TaskItem]
    
    var body: some View {
        List(tasks) { task in
            VStack(alignment: .leading) {
                Text(task.title)
                    .bold()
                Text(task.details)
                    .foregroundColor(.secondary)
                Text(task.dueDate, style: .time)
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle(tasks.first?.dueDate.formatted(.dateTime.day(.twoDigits).month(.abbreviated)) ?? StringConstants.tasks)
    }
}
