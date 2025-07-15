//
//  TaskEditView.swift
//  Tasks
//
//  Created by Rahul Serodia on 14/07/25.
//

import SwiftUI

private struct Constants {
    static let title = "Title"
    static let cancel = "Cancel"
    static let save = "Save"
}

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
                    TextField(Constants.title, text: $title)
                    TextEditor(text: $details)
                        .frame(height: 80)
                    DatePicker(StringConstants.dueDate, selection: $dueDate)
                    Picker(StringConstants.priority, selection: $priority) {
                        ForEach(Priority.selectableCases) { priority in
                            Text(priority.value)
                                .tag(priority)
                        }
                    }
                }
                if taskToEdit != nil {
                    Toggle(StringConstants.completed, isOn: $isCompleted)
                }
            }
            .navigationTitle("\(taskToEdit == nil ? "Add" : "Edit") Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(Constants.cancel) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(Constants.save) {
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
