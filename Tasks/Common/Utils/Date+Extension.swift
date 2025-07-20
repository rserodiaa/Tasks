//
//  Date+Extension.swift
//  Tasks
//
//  Created by Rahul Serodia on 16/07/25.
//

import Foundation

extension Date {
    func formatted() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}

extension DateFormatter {
    private static func make(with format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter
    }

    static let monthYear = make(with: "MMMM yyyy")
    static let day = make(with: "d")
    static let month = make(with: "MMM")
}
