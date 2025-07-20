//
//  TabsButton.swift
//  Splitshare
//
//  Created by Rahul Serodia on 01/06/25.
//

import SwiftUI


struct TabViewButton: View {
    var image: String
    let index: Int
    @Binding var selectedTab: String
    @Binding var peakPoints: [CGFloat]
    
    var body: some View {
        
        GeometryReader { geometry -> AnyView in
            let midX = geometry.frame(in: .global).midX

            DispatchQueue.main.async {
                    if peakPoints.count > index {
                        peakPoints[index] = midX
                    } else if peakPoints.count == index {
                        peakPoints.append(midX)
                    }
                }
            
            return AnyView(
                Button {
                    withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.5, blendDuration: 0.5)) {
                        selectedTab = image
                    }
                }
                    
                label: {
                    Image(systemName: "\(image)\(selectedTab == image ? ".fill" : "")")
                        .font(.system(size: 30, weight: .semibold))
                        .offset(y: selectedTab == image ? -10 : 0)
                        .animation(.easeIn(duration: 0.1), value: selectedTab)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                )
        }
        .frame(height: 50)
    }
}
