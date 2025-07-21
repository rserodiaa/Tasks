//
//  TaskListView.swift
//  Tasks
//
//  Created by Rahul Serodia on 14/07/25.
//

import SwiftUI

private struct Constants {
    static let filter = "Filter"
    static let errorTitle = "Error"
    static let ok = "OK"
}

struct TaskListView: View {
    @StateObject var controller: TaskController
    @State private var showCreate = false
    
    var body: some View {
        NavigationStack {
            VStack {
                sortAndFilterRow
                List {
                    ForEach(controller.tasks) { task in
                        NavigationLink(value: task) {
                            TaskCard(task: task)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                        }
                    }
                    .onDelete(perform: deleteTasks)
                }
                .padding(.bottom, 60)
                .scrollIndicators(.hidden)
                .scrollContentBackground(.hidden)
                .background(Color.white.opacity(0.2))
            }
            .fullScreenBackground()
            .navigationTitle(StringConstants.tasks)
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
            .navigationDestination(for: TaskItem.self) { task in
                TaskDetailView(controller: controller, task: task)
            }
            .sheet(isPresented: $showCreate) {
                TaskEditView(
                    controller: controller,
                    taskToEdit: nil
                )
            }
        }
        .task {
            await controller.loadTasks()
        }
        .alert(Constants.errorTitle, isPresented: $controller.showErrorAlert) {
            Button(Constants.ok, role: .cancel) { }
        } message: {
            Text(controller.errorMessage)
        }
    }
    
    private var sortAndFilterRow: some View {
        return HStack {
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
    }
    
    private func deleteTasks(at offsets: IndexSet) {
        Task {
            for index in offsets {
                let task = controller.tasks[index]
                await controller.delete(task)
            }
        }
    }
}

#Preview {
    TaskListView(controller: .preview)
}
