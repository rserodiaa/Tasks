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
