//
//  TaskCard.swift
//  Tasks
//
//  Created by Rahul Serodia on 18/07/25.
//

import SwiftUI

struct TaskCard: View {
    let task: Task
    
    var body: some View {
        HStack(spacing: 16) {
            DateBadge(date: task.dueDate)
            
            VStack(alignment: .leading) {
                Text(task.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(task.clippedDetails)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 8) {
                    Text(Priority(safeRawValue: task.priority).value)
                        .font(.caption2)
                        .bold()
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .foregroundColor(.white)
                        .background(Priority(safeRawValue: task.priority).color)
                        .cornerRadius(5)
                    
                    if let status = task.statusImage {
                        Image(systemName: status.imageName)
                            .foregroundColor(status.color)
                    }
                    
                    Spacer()
                }
            }
            
        }
    }
}

