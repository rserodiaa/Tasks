//
//  TaskListView.swift
//  Tasks
//
//  Created by Rahul Serodia on 14/07/25.
//

import SwiftUI

struct TaskListView: View {
    @StateObject var controller: TaskController

    @State private var sortOption: SortOption = .dueDate
    @State private var filterOption: FilterOption = .all
    @State private var showCreate = false

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Picker("Filter", selection: $filterOption) {
                        ForEach(FilterOption.allCases) { option in
                            Text(option.id).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)

                    Menu {
                        ForEach(SortOption.allCases) { option in
                            Button {
                                sortOption = option
                            } label: {
                                Text(option.id)
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down.circle")
                            .font(.title2)
                    }
                }
                .padding(.horizontal)

                List {
                    ForEach(controller.tasks) { task in
                        NavigationLink(value: task) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(task.title)
                                        .font(.headline)
                                    Text("Due: \(task.dueDate, formatter: dateFormatter)")
                                        .font(.subheadline)
                                }
                                Spacer()
                                Text(priorityText(task.priority))
                                    .foregroundColor(priorityColor(task.priority))
                                if task.isCompleted {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                } else if task.dueDate < Date() {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteTask)
                }
                .listStyle(.plain)
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showCreate = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .onChange(of: sortOption) { _, _ in
                controller.fetchTasks(sortBy: sortOption, filter: filterOption)
            }
            .onChange(of: filterOption) { _, _ in
                controller.fetchTasks(sortBy: sortOption, filter: filterOption)
            }
            .navigationDestination(for: Task.self) { task in
                TaskDetailView(controller: controller, task: task)
            }
            .sheet(isPresented: $showCreate) {
                TaskEditView(
                    controller: controller,
                    taskToEdit: nil
                )
            }
        }
    }

    private func deleteTask(at offsets: IndexSet) {
//        Task {
            for index in offsets {
                let task = controller.tasks[index]
                controller.deleteTask(task)
            }
//        }
    }
    
    func priorityText(_ priority: Int) -> String {
        switch priority {
        case 1: return "High"
        case 2: return "Medium"
        default: return "Low"
        }
    }
    func priorityColor(_ priority: Int) -> Color {
        switch priority {
        case 1: return .red
        case 2: return .orange
        default: return .gray
        }
    }
}

