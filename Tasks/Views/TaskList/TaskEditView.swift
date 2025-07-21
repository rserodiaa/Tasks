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
    static let reminders = "Reminders"
    static let status = "Status"
    static let add = "Add"
    static let edit = "Edit"
    static let task = "Task"
}

struct TaskEditView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var controller: TaskController

    @State var title: String = ""
    @State var details: String = ""
    @State var dueDate: Date = .now
    @State var priority: Priority = .medium
    @State var isCompleted: Bool = false
    @State private var isReminderEnabled: Bool = false

    let taskToEdit: TaskItem?

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
                
                Section(Constants.reminders) {
                    Toggle(StringConstants.setReminder, isOn: $isReminderEnabled)
                }
                
                if taskToEdit != nil {
                    Section(Constants.status) {
                        Toggle(StringConstants.completed, isOn: $isCompleted)
                    }
                }
            }
            .navigationTitle("\(taskToEdit == nil ? Constants.add : Constants.edit) \(Constants.task)")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(Constants.cancel) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(Constants.save) {
                        Task {
                            if let task = taskToEdit {
                                await controller.updateTask(
                                    task,
                                    title: title,
                                    details: details,
                                    dueDate: dueDate,
                                    priority: priority.id,
                                    isCompleted: isCompleted,
                                    setReminder: isReminderEnabled
                                )
                            } else {
                                await controller.addTask(
                                    title: title,
                                    details: details,
                                    dueDate: dueDate,
                                    priority: priority.id,
                                    setReminder: isReminderEnabled
                                )
                            }
                            dismiss()
                        }
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
