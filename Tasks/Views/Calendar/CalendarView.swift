//
//  CalendarView.swift
//  Tasks
//
//  Created by Rahul Serodia on 18/07/25.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var controller: TaskController
    @State private var currentMonth = Calendar.current.component(.month, from: Date())
    @State private var currentYear = Calendar.current.component(.year, from: Date())
    
    var body: some View {
        VStack(spacing: 0) {
            calenderHeader
            dayLabels
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(allDaysInMonth(month: currentMonth, year: currentYear), id: \.self) { date in
                    NavigationLink(value: date) {
                        CalendarDateView(date: date, controller: controller)
                    }
                }
            }
            .padding(.horizontal)
        }
        .navigationDestination(for: Date.self) { date in
            CalendarDateListView(tasks: controller.tasksByDay[date] ?? [])
        }
    }
    
    private var dayLabels: some View {
        let labels = Calendar.current.shortWeekdaySymbols
        return HStack {
            ForEach(labels, id: \.self) { label in
                Text(label)
                    .font(.caption)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal)
    }
    
    private var calenderHeader: some View {
        return HStack {
            Button { updateMonth(-1) } label: {
                Image(systemName: ImageConstants.left).font(.headline)
            }
            Text(currentMonthTitle())
                .font(.title2)
                .frame(maxWidth: .infinity)
            Button { updateMonth(1) } label: {
                Image(systemName: ImageConstants.right).font(.headline)
            }
        }
        .padding()
    }
    
    private func allDaysInMonth(month: Int, year: Int) -> [Date] {
        let calendar = Calendar.current
        let date = calendar.date(from: DateComponents(year: year, month: month))!
        let range = calendar.range(of: .day, in: .month, for: date)!
        return (1...range.count).map { day in
            Calendar.current.date(from: DateComponents(year: currentYear, month: currentMonth, day: day))!
        }
    }
    
    private func updateMonth(_ change: Int) {
        let newMonth = currentMonth + change
        if newMonth < 1 {
            currentMonth = 12
            currentYear -= 1
        } else if newMonth > 12 {
            currentMonth = 1
            currentYear += 1
        } else {
            currentMonth = newMonth
        }
    }
    
    func currentMonthTitle() -> String {
        return DateFormatter.monthYear.string(from: Calendar.current.date(from: DateComponents(year: currentYear, month: currentMonth))!)
    }
    

}

#Preview {
    NavigationStack {
        CalendarView(controller: .preview)
    }
}
