//
//  TaskDetailView.swift
//  Tasks
//
//  Created by Rahul Serodia on 14/07/25.
//

import SwiftUI

struct TaskDetailView: View {
    @ObservedObject var controller: TaskController
    @State var task: TaskItem
    @State private var showEdit = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                VStack(alignment: .leading, spacing: 16) {
                    Text(task.title)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color.primaryText)

                    if !task.details.isEmpty {
                        Text(task.details)
                            .font(.body)
                            .foregroundColor(Color.secondaryText)
                    }

                    Divider().padding(.vertical, 4)

                    infoRow(icon: ImageConstants.calendar, label: StringConstants.dueDate, value: task.dueDate.formatted())
                    infoRow(icon: ImageConstants.flag, label: StringConstants.priority, value: Priority(safeRawValue: task.priority).value, color: Priority(safeRawValue: task.priority).color)

                    Toggle(isOn: $task.isCompleted) {
                        Label(task.isCompleted ? "Completed" : "Mark as Completed",
                              systemImage: task.isCompleted ? ImageConstants.checkmark : ImageConstants.circle)
                            .foregroundColor(task.isCompleted ? .green : .gray)
                            .font(.subheadline.weight(.medium))
                    }
                    .onChange(of: task.isCompleted) { _, _ in
                        Task {
                            await controller.updateTask(
                                task,
                                title: task.title,
                                details: task.details,
                                dueDate: task.dueDate,
                                priority: task.priority,
                                isCompleted: task.isCompleted
                            )
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.lightBlue.opacity(0.85))
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
                Button {
                    Task {
                        await controller.delete(task)
                    }
                } label: {
                    Image(systemName: ImageConstants.trash)
                }
                .controlSize(.mini)
            }
        }
        .sheet(isPresented: $showEdit) {
            TaskEditView(
                controller: controller,
                title: task.title,
                details: task.details,
                dueDate: task.dueDate,
                priority: Priority(safeRawValue: task.priority),
                isCompleted: task.isCompleted,
                taskToEdit: task
            )
        }
    }    
}

private struct infoRow: View {
    let icon, label, value: String
    var color: Color = Color.primaryText
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 20)
            VStack(alignment: .leading) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(Color.secondaryText)
                Text(value)
                    .font(.body.weight(.medium))
                    .foregroundColor(color)
            }
        }
    }
}

#Preview {
    TaskDetailView(controller: .preview, task: TaskController.mockTask.first!)
}
