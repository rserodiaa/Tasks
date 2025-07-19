//
//  CalendarDateView.swift
//  Tasks
//
//  Created by Rahul Serodia on 18/07/25.
//

import SwiftUI

struct CalendarDateView: View {
    let date: Date
    let tasks: [TaskItem]

    var body: some View {
        let day = Calendar.current.component(.day, from: date)
        let isToday = Calendar.current.isDate(date, inSameDayAs: Date())

        ZStack(alignment: .center) {
            Circle()
                .fill(isToday ? Color.blue : Color.clear)
                .frame(width: 36, height: 36)
                .overlay(
                    Text("\(day)")
                        .fontWeight(.medium)
                        .foregroundColor(isToday ? .white : .primary)
                )

            // Color dot indicator for tasks
            if !tasks.isEmpty {
                Rectangle()
                    .fill(Priority(safeRawValue: tasks.first!.priority).color)
                    .frame(width: 6, height: 6)
                    .cornerRadius(3)
                    .offset(y: 25)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
    }
}
