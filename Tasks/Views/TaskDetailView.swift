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
        ScrollView {
            VStack(spacing: 24) {


                // Info Card
                VStack(alignment: .leading, spacing: 16) {
                    // Title
                    Text(task.title)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)

                    // Details
                    if !task.details.isEmpty {
                        Text(task.details)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }

                    Divider().padding(.vertical, 4)

                    // Info Rows
                    infoRow(icon: "calendar", label: StringConstants.dueDate, value: controller.formattedDueDate(task.dueDate))
                    infoRow(icon: "flag.fill", label: StringConstants.priority, value: controller.priorityDisplayValue(task.priority), color: controller.priorityColor(task.priority))

                    // Toggle
                    Toggle(isOn: $task.isCompleted) {
                        Label(task.isCompleted ? "Completed" : "Mark as Completed",
                              systemImage: task.isCompleted ? "checkmark.seal.fill" : "circle")
                            .foregroundColor(task.isCompleted ? .green : .gray)
                            .font(.subheadline.weight(.medium))
                    }
                    .onChange(of: task.isCompleted) { _, _ in
                        controller.updateTask(
                            task,
                            title: task.title,
                            details: task.details,
                            dueDate: task.dueDate,
                            priority: task.priority,
                            isCompleted: task.isCompleted
                        )
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.orange.opacity(0.15))
                        .background(.regularMaterial)
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 6)
                .padding(.horizontal)
                .padding(.top, 40)
            }
        }
        
        .background(LinearGradient(colors: [.blue.opacity(0.1), .white], startPoint: .top, endPoint: .bottom).ignoresSafeArea())
        
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(StringConstants.edit) {
                    showEdit = true
                }
            }

            ToolbarItem(placement: .destructiveAction) {
                Button(role: .destructive) {
                    controller.delete(task)
                } label: {
                    Image(systemName: ImageConstants.trash)
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
}

struct infoRow: View {
    let icon, label, value: String
    var color: Color = .primary
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 20)
            VStack(alignment: .leading) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.body.weight(.medium))
                    .foregroundColor(color)
            }
        }}
}

#Preview {
    TaskDetailView(controller: .preview, task: Task(title: "Finish Assignment", details: "Complete all partsComplete all partsComplete all partsComplete all partsComplete all partsComplete all partsComplete all partsComplete all partsComplete all partsComplete all partsComplete all partsComplete all partsComplete all partsComplete all partsComplete all partsComplete all partsComplete all partsComplete all partsComplete all parts", isCompleted: false, dueDate: Date(), priority: 2))
}
