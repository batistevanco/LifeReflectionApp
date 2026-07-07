//
//  WeeklyReviewCard.swift
//  LifeReflectionApp
//

import SwiftUI
import SwiftData

struct WeeklyReviewCard: View {
    @Query private var milestones: [Milestone]
    @Query private var letters: [Letter]
    @Query private var wealthEntries: [WealthEntry]
    @Query private var dreams: [Dream]

    private var weekStart: Date {
        Calendar.current.date(byAdding: .day, value: -7, to: .now) ?? .now
    }

    private var newMilestones: Int {
        milestones.filter { $0.date >= weekStart }.count
    }
    private var newLetters: Int {
        letters.filter { $0.dateWritten >= weekStart }.count
    }
    private var newWealthEntries: [WealthEntry] {
        wealthEntries.filter { $0.date >= weekStart }
    }
    private var fulfilledThisWeek: Int {
        dreams.filter { ($0.fulfilledDate ?? .distantPast) >= weekStart }.count
    }

    private var hasActivity: Bool {
        newMilestones > 0 || newLetters > 0 || !newWealthEntries.isEmpty || fulfilledThisWeek > 0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Deze week")
                .font(.caption)
                .textCase(.uppercase)
                .foregroundStyle(Theme.textSecondary)

            if hasActivity {
                Text("Je denkt misschien dat je deze week niet vooruitging, maar:")
                    .font(.subheadline)
                    .foregroundStyle(Theme.textSecondary)

                VStack(alignment: .leading, spacing: 6) {
                    if newMilestones > 0 {
                        reviewLine("✨ \(newMilestones) \(newMilestones == 1 ? "nieuw moment" : "nieuwe momenten") vastgelegd")
                    }
                    if fulfilledThisWeek > 0 {
                        reviewLine("💫 \(fulfilledThisWeek) \(fulfilledThisWeek == 1 ? "droom" : "dromen") waargemaakt")
                    }
                    if newLetters > 0 {
                        reviewLine("💌 \(newLetters) \(newLetters == 1 ? "brief" : "brieven") aan je toekomstige zelf")
                    }
                    if !newWealthEntries.isEmpty {
                        reviewLine("📊 Je vermogen bijgewerkt")
                    }
                }

                Text("Je bént vooruitgegaan.")
                    .font(Theme.quoteFont)
                    .foregroundStyle(Theme.accent)
                    .padding(.top, 2)
            } else {
                Text("Een rustige week is ook vooruitgang. Alles wat je tot nu toe hebt opgebouwd, is er nog steeds.")
                    .font(Theme.quoteFont)
                    .foregroundStyle(Theme.accent)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }

    private func reviewLine(_ text: String) -> some View {
        Text(text)
            .font(.subheadline)
            .foregroundStyle(Theme.textPrimary)
    }
}

#Preview {
    WeeklyReviewCard()
        .modelContainer(for: [Milestone.self, Dream.self, Letter.self, WealthEntry.self], inMemory: true)
        .padding()
}
