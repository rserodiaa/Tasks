//
//  TaskEditView.swift
//  Tasks
//
//  Created by Rahul Serodia on 14/07/25.
//

import SwiftUI

struct TaskEditView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var controller: TaskController

    @State var title: String = ""
    @State var details: String = ""
    @State var dueDate: Date = .now
    @State var priority: Priority = .medium
    @State var isCompleted: Bool = false

    let taskToEdit: Task?

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $title)
                    TextEditor(text: $details)
                        .frame(height: 80)
                    DatePicker("Due Date", selection: $dueDate)
                    Picker("Priority", selection: $priority) {
                        ForEach(Priority.allCases) { priority in
                            Text(priority.value)
                                .tag(priority)
                        }
                    }
                }
                if taskToEdit != nil {
                    Toggle("Completed", isOn: $isCompleted)
                }
            }
            .navigationTitle(taskToEdit == nil ? "Add Task" : "Edit Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let task = taskToEdit {
                            controller.updateTask(task, title: title, details: details, dueDate: dueDate, priority: priority.id, isCompleted: isCompleted)
                        } else {
                            controller.addTask(title: title, details: details, dueDate: dueDate, priority: priority.id)
                        }
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
