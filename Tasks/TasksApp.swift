//
//  TasksApp.swift
//  Tasks
//
//  Created by Rahul Serodia on 14/07/25.
//

import SwiftUI
import SwiftData

@main
struct TasksApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            TaskItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            let notificationService = NotificationService.shared
            let repository = TaskRepository(context: sharedModelContainer.mainContext)
            let controller = TaskController(repository: repository, notificationService: notificationService)
            MainTabView(controller: controller)
                            .tint(Color.primaryColor)
        }
    }
}
