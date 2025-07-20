//
//  TabsCurve.swift
//  Splitshare
//
//  Created by Rahul Serodia on 01/06/25.
//

import SwiftUI

struct TabsCurve: Shape {
    
    var peakPoint: CGFloat
    var animatableData: CGFloat {
        get { peakPoint }
        set { peakPoint = newValue }
    }
    func path(in rect: CGRect) -> Path {
        return Path { path in
            
            path.move(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            
            let mid = peakPoint

            // Start curve from left side of the middle section
            path.move(to: CGPoint(x: mid - 40, y: rect.height))

            // First curve peak (upward curve)
            let to = CGPoint(x: mid, y: rect.height - 20)
            let control1 = CGPoint(x: mid - 15, y: rect.height)
            let control2 = CGPoint(x: mid - 15, y: rect.height - 20)

            // Second curve dip (downward back to bottom)
            let to1 = CGPoint(x: mid + 40, y: rect.height)
            let control3 = CGPoint(x: mid + 15, y: rect.height - 20)
            let control4 = CGPoint(x: mid + 15, y: rect.height)

            // Add the curves
            path.addCurve(to: to, control1: control1, control2: control2)
            path.addCurve(to: to1, control1: control3, control2: control4)
        }
    }
    
}
