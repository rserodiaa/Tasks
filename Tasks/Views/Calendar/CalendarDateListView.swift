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
        ZStack {
            Image("backdrop")
                .resizable()
                .ignoresSafeArea()
            List(tasks) { task in
                TaskCard(task: task)
            }
            .scrollContentBackground(.hidden)
            .background(Color.white.opacity(0.3))
        }
        .navigationTitle(tasks.first?.dueDate.formatted(.dateTime.day(.twoDigits).month(.abbreviated)) ?? StringConstants.tasks)
    }
}
