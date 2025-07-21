//
//  CalendarDateListView.swift
//  Tasks
//
//  Created by Rahul Serodia on 18/07/25.
//

import SwiftUI

struct CalendarDateListView: View {
    let tasks: [TaskItem]
    
    var body: some View {
            VStack(spacing: 16) {
                if let date = tasks.first?.dueDate {
                    VStack(spacing: 4) {
                        Image(systemName: ImageConstants.calendarCircle)
                            .font(.system(size: 40))
                            .foregroundStyle(.orange.gradient)
                        
                        Text(date.formatted(.dateTime.day().month(.wide).year()))
                            .font(.title3.weight(.medium))
                            .foregroundStyle(.primary)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 10)
                }
                
                List(tasks) { task in
                    TaskCard(task: task)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                }
                .scrollContentBackground(.hidden)
                .background(Color.white.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 25))
            }
            .padding(.top, 32)
            .padding(.horizontal)
            .fullScreenBackground()
            .navigationTitle("")
    }
}

#Preview {
    CalendarDateListView(tasks: TaskController.mockTask)
}
