//
//  Priority.swift
//  Tasks
//
//  Created by Rahul Serodia on 16/07/25.
//

import SwiftUI

enum Priority: Int, CaseIterable, Identifiable {
    case high = 1
    case medium
    case low
    case unknown
    
    var id: Int { self.rawValue }
    
    init(safeRawValue: Int) {
        self = Priority(rawValue: safeRawValue) ?? .unknown
    }
    
    static let selectableCases: [Priority] = [.high, .medium, .low]
    
    var value: String {
        switch self {
        case .high: return "High"
        case .medium: return "Medium"
        case .low: return "Low"
        case .unknown: return "Unknown"
        }
    }
    
    var color: Color {
        switch self {
        case .high: return .red
        case .medium: return .orange
        case .low: return .yellow
        case .unknown: return .blue
        }
    }
}
    
