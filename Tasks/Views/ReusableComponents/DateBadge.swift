//
//  DateBadge.swift
//  Tasks
//
//  Created by Rahul Serodia on 15/07/25.
//

import SwiftUI

struct DateBadge: View {
    let date: Date
    
    var day: String {
        return DateFormatter.day.string(from: date)
    }
    
    var month: String {
        return DateFormatter.month.string(from: date).uppercased()
    }

    var body: some View {
        VStack(spacing: 0) {
            Text(day)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(4)
                .background(Color.calendarTop)

            Text(month)
                .font(.footnote)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(3)
                .background(Color.calendarBottom)
        }
        .frame(width: 40, height: 50)
        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
        .shadow(radius: 1)
    }
}

#Preview {
    DateBadge(date: .now)
}
