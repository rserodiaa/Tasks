//
//  MainTabsView.swift
//  Tasks
//
//  Created by Rahul Serodia on 18/07/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = CustomTabs.home.rawValue
    @ObservedObject var controller: TaskController
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                if selectedTab == CustomTabs.home.rawValue {
                    TaskListView(controller: controller)
                        .transition(.opacity)
                } else if selectedTab == CustomTabs.calendar.rawValue {
                    CalendarView(controller: controller)
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: selectedTab)
            CustomTabView(selectedTab: $selectedTab)
                .padding(.bottom, 30)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    MainTabView(controller: .preview)
}
