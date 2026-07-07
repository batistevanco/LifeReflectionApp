//
//  MainTabView.swift
//  LifeReflectionApp
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    var body: some View {
        TabView {
            TodayView()
                .tabItem { Label("Vandaag", systemImage: "sun.max") }
            MilestoneTimelineView()
                .tabItem { Label("Tijdlijn", systemImage: "clock.arrow.circlepath") }
            DreamsView()
                .tabItem { Label("Dromen", systemImage: "sparkles") }
            LettersView()
                .tabItem { Label("Brieven", systemImage: "envelope") }
            WealthView()
                .tabItem { Label("Vermogen", systemImage: "chart.line.uptrend.xyaxis") }
        }
        .tint(Theme.accent)
    }
}

#Preview {
    MainTabView()
        .modelContainer(for: [Milestone.self, Dream.self, Letter.self, WealthEntry.self, UserProfile.self], inMemory: true)
}
