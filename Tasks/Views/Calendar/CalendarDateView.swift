//
//  CalendarDateView.swift
//  Tasks
//
//  Created by Rahul Serodia on 18/07/25.
//

import SwiftUI

struct CalendarDateView: View {
    let date: Date
    let hasTasks: Bool

    var body: some View {
        let day = Calendar.current.component(.day, from: date)
        let isToday = Calendar.current.isDate(date, inSameDayAs: Date())

        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 8)
                .fill(isToday ? Color.blue : Color.primaryColor.opacity(0.2))
                .frame(width: 36, height: 36)
                .overlay(
                    Text("\(day)")
                        .fontWeight(.medium)
                        .foregroundColor(isToday ? .white : .primary)
                )

            // Color dot indicator for tasks
            if hasTasks {
                Circle()
                    .fill(.blue)
                    .frame(width: 6, height: 6)
                    .offset(y: 23)
                    
            }
        }
        .padding(.bottom, 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
    }
}

#Preview {
    CalendarDateView(date: .distantPast,
                     hasTasks: true)
}
