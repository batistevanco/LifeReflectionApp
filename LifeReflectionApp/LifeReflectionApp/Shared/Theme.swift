//
//  Theme.swift
//  LifeReflectionApp
//

import SwiftUI

enum Theme {
    static let background = Color(red: 0.98, green: 0.97, blue: 0.94)
    static let cardBackground = Color.white
    static let accent = Color(red: 0.55, green: 0.47, blue: 0.37)
    static let textPrimary = Color(red: 0.16, green: 0.14, blue: 0.12)
    static let textSecondary = Color(red: 0.45, green: 0.42, blue: 0.38)

    static let heroFont = Font.system(.title, design: .serif).weight(.medium)
    static let quoteFont = Font.system(.title3, design: .serif).italic()
    static let cardTitleFont = Font.system(.headline, design: .rounded)
}

struct CardBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(20)
            .background(Theme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardBackground())
    }
}
