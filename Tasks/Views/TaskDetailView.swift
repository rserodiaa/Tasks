//
//  TaskDetailView.swift
//  Tasks
//
//  Created by Rahul Serodia on 14/07/25.
//

import SwiftUI

struct TaskDetailView: View {
    @ObservedObject var controller: TaskController
    @State var task: Task
    @State private var showEdit = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(task.title).font(.largeTitle)
            Text(task.details).font(.body)
            Text("Due: \(task.dueDate, formatter: dateFormatter)")
            Text("Priority: \(priorityText(task.priority))")
            Toggle("Completed", isOn: $task.isCompleted)
                .onChange(of: task.isCompleted) { _, _ in
                    controller.updateTask(task, title: task.title, details: task.details, dueDate: task.dueDate, priority: task.priority, isCompleted: task.isCompleted)
                }
            Spacer()
        }
        .padding()
        .navigationTitle("Task Details")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Edit") { showEdit = true }
            }
            ToolbarItem(placement: .destructiveAction) {
                Button(role: .destructive) {
                    controller.deleteTask(task)
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
        .sheet(isPresented: $showEdit) {
            TaskEditView(
                controller: controller,
                title: task.title,
                details: task.details,
                dueDate: task.dueDate,
                priority: Priority(rawValue: task.priority) ?? .medium,
                isCompleted: task.isCompleted,
                taskToEdit: task
            )
        }
    }

    func priorityText(_ priority: Int) -> String {
        switch priority {
        case 1: return "High"
        case 2: return "Medium"
        default: return "Low"
        }
    }
}
