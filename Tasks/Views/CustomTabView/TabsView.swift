//
//  TabsView.swift
//  Splitshare
//
//  Created by Rahul Serodia on 01/06/25.
//

import SwiftUI

struct CustomTabView: View {
    @Binding var selectedTab: String
    @State var peakPoints: [CGFloat] = [0,0]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(CustomTabs.allCases.enumerated()), id: \.offset) { index, tab in
                    TabViewButton(
                        image: tab.rawValue,
                        index: index,
                        selectedTab: $selectedTab,
                        peakPoints: $peakPoints
                    )
                }
            }
        .padding()
        .background(Color.primaryColor
            .clipShape(TabsCurve(peakPoint: getCurvePoint() - 18)))
        .overlay(Circle()
            .fill(Color.primaryColor)
            .frame(width: 10, height: 10)
            .offset(x: getCurvePoint() - 22)
                 , alignment: .bottomLeading
        )
        .cornerRadius(30)
        .padding(.horizontal, 20)
        
    }
    
    func getCurvePoint() -> CGFloat {
        if peakPoints.isEmpty {
            return 10
        } else {
            switch selectedTab {
            case CustomTabs.home.rawValue:
                return peakPoints[0]
            default:
                return peakPoints[1]
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedTab = CustomTabs.home.rawValue
    CustomTabView(selectedTab: $selectedTab)
}
