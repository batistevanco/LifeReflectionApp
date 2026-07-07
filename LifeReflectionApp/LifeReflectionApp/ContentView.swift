//
//  ContentView.swift
//  LifeReflectionApp
//

import SwiftUI
import SwiftData

struct RootView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]

    var body: some View {
        Group {
            if let profile = profiles.first, profile.onboardingComplete {
                MainTabView()
            } else {
                OnboardingView()
            }
        }
        .onAppear {
            if profiles.isEmpty {
                modelContext.insert(UserProfile())
            }
        }
    }
}

#Preview {
    RootView()
        .modelContainer(for: [Milestone.self, Dream.self, Letter.self, WealthEntry.self, UserProfile.self], inMemory: true)
}
