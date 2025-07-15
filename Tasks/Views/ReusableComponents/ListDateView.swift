//
//  ListDateView.swift
//  Tasks
//
//  Created by Rahul Serodia on 15/07/25.
//

import SwiftUI

struct ListDateView: View {
    let date: Date
    
    var day: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    var month: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: date).uppercased()
    }

    var body: some View {
        VStack(spacing: 0) {
            Text(day)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(3)
                .background(Color.orange)

            Text(month)
                .font(.footnote)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(3)
                .background(Color.purple)
        }
        .frame(width: 40, height: 50)
        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
        .shadow(radius: 1)
    }
}

#Preview {
    ListDateView(date: .now)
}
