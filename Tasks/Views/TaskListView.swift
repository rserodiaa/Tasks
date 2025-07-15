//
//  TaskListView.swift
//  Tasks
//
//  Created by Rahul Serodia on 14/07/25.
//

import SwiftUI

private struct Constants {
    static let filter = "Filter"
    static let tasks = "Tasks"
}

struct TaskListView: View {
    @StateObject var controller: TaskController
    @State private var showCreate = false

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Picker(Constants.filter, selection: $controller.filterOption) {
                        ForEach(FilterOption.allCases) { option in
                            Text(option.id).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)

                    Menu {
                        ForEach(SortOption.allCases) { option in
                            Button {
                                controller.sortOption = option
                            } label: {
                                Text(option.id)
                            }
                        }
                    } label: {
                        Image(systemName: ImageConstants.sort)
                            .font(.title2)
                    }
                }
                .padding(.horizontal)

                List {
                    ForEach(controller.tasks) { task in
                        NavigationLink(value: task) {
                            HStack {
                                ListDateView(date: task.dueDate)
                                
                                VStack(alignment: .leading) {
                                    Text(task.title)
                                        .font(.headline)
                                    Text(task.clippedDetails)
                                        .font(.subheadline)
                                        
    
                                }
                                Spacer()
                                Text(Priority(safeRawValue: task.priority).value)
                                    .foregroundColor(Priority(safeRawValue: task.priority).color)
                                if let status = task.statusImage {
                                    Image(systemName: status.systemName)
                                        .foregroundColor(status.color)
                                }
                            }
                        }
                    }
                    .onDelete(perform: controller.deleteTask)
                }
                .listStyle(.plain)
            }
            .navigationTitle(Constants.tasks)
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showCreate = true
                    } label: {
                        Image(systemName: ImageConstants.plus)
                    }
                }
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
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView(controller: .preview)
    }
}
