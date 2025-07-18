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
    @State var selectedTab = CustomTabs.home.rawValue

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
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
                            TaskCard(task: task)
                        }
                    }
                    .onDelete(perform: controller.deleteTask)
                }
                .listStyle(.plain)
            }
                CustomTabView(selectedTab: $selectedTab)
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

#Preview {
    TaskListView(controller: .preview)
}
