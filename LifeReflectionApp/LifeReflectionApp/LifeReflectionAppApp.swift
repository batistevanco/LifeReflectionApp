//
//  LifeReflectionAppApp.swift
//  LifeReflectionApp
//
//  Created by Batiste Vancoillie on 07/07/2026.
//

import SwiftUI
import SwiftData

@main
struct LifeReflectionAppApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: [Milestone.self, Dream.self, Letter.self, WealthEntry.self, UserProfile.self])
    }
}
