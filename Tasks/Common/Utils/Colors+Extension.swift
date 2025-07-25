//
//  Colors+Extension.swift
//  Tasks
//
//  Created by Rahul Serodia on 25/07/25.
//

import SwiftUI

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
    
    static let primaryColor = Color(hex: 0x4464AD)
    
    static let calendarTop = Color(hex: 0x47A8BD)
    static let calendarBottom = Color(hex: 0x1E3888)
    
    static let lowPriority = Color(hex: 0xF9DC5C)
    static let mediumPriority = Color(hex: 0xFFAD69)
    static let highPriority = Color(hex: 0xD16666)
    
    static let lightBlue = Color(hex: 0xBFDBF7)
    
    static let primaryText = Color(hex: 0x403D39)
    static let secondaryText = Color(hex: 0x7989A4)
}
