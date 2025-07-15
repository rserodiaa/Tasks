//
//  Task+Extension.swift
//  Tasks
//
//  Created by Rahul Serodia on 16/07/25.
//
import SwiftUI

extension Task {
    var clippedDetails: String {
        return details.truncated(to: 60)
    }
    
    var statusImage: (systemName: String, color: Color)? {
        if isCompleted { return (ImageConstants.checkmark, .green) }
        else if dueDate < .now { return (ImageConstants.exclamation, .red) }
        else { return nil }
    }
}
