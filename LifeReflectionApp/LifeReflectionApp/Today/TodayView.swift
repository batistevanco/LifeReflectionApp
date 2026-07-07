//
//  TodayView.swift
//  LifeReflectionApp
//

import SwiftUI
import SwiftData

struct TodayView: View {
    @Query(sort: \Milestone.date, order: .reverse) private var milestones: [Milestone]
    @Query(sort: \WealthEntry.date) private var wealthEntries: [WealthEntry]
    @Query private var profiles: [UserProfile]

    @State private var showAddMilestone = false
    @State private var appeared = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    heroSection

                    WeeklyReviewCard()

                    if let latest = milestones.first {
                        latestMilestoneCard(latest)
                    }

                    if wealthEntries.count >= 2 {
                        wealthProgressCard
                    }

                    if let memory = onThisDayMilestone {
                        onThisDayCard(memory)
                    }

                    addMomentButton
                }
                .padding()
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 12)
            }
            .background(Theme.background.ignoresSafeArea())
            .navigationTitle("Vandaag")
            .sheet(isPresented: $showAddMilestone) {
                AddMilestoneView()
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.7)) {
                    appeared = true
                }
            }
        }
    }

    private var heroSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("🌱 Je bent verder dan je denkt.")
                .font(Theme.heroFont)
                .foregroundStyle(Theme.textPrimary)
            Text(heroSubtitle)
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
        }
        .padding(.vertical, 8)
    }

    private var heroSubtitle: String {
        if let profile = profiles.first {
            let age = Calendar.current.component(.year, from: .now) - profile.birthYear
            if !milestones.isEmpty {
                return "\(age) jaar, en al \(milestones.count) \(milestones.count == 1 ? "moment" : "momenten") om trots op te zijn."
            }
            return "\(age) jaar en volop aan het groeien."
        }
        return "Elke dag telt."
    }

    private func latestMilestoneCard(_ milestone: Milestone) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Je laatste moment")
                .font(.caption)
                .textCase(.uppercase)
                .foregroundStyle(Theme.textSecondary)

            if let data = milestone.photoData, let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }

            Text(milestone.title)
                .font(Theme.cardTitleFont)
                .foregroundStyle(Theme.textPrimary)
            Text(milestone.date.formatted(date: .long, time: .omitted))
                .font(.caption)
                .foregroundStyle(Theme.textSecondary)

            if let quote = milestone.oldSelfQuote, !quote.isEmpty {
                Text("\"\(quote)\"")
                    .font(Theme.quoteFont)
                    .foregroundStyle(Theme.accent)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }

    private var wealthProgressCard: some View {
        let first = wealthEntries.first!
        let last = wealthEntries.last!
        let diff = last.amount - first.amount
        return VStack(alignment: .leading, spacing: 8) {
            Text("Je groei")
                .font(.caption)
                .textCase(.uppercase)
                .foregroundStyle(Theme.textSecondary)
            Text(last.amount, format: .currency(code: "EUR").precision(.fractionLength(0)))
                .font(Theme.cardTitleFont)
                .foregroundStyle(Theme.textPrimary)
            if diff != 0 {
                Text("\(diff > 0 ? "📈 +" : "")\(diff.formatted(.currency(code: "EUR").precision(.fractionLength(0)))) sinds \(first.date.formatted(.dateTime.month(.wide).year()))")
                    .font(.subheadline)
                    .foregroundStyle(Theme.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }

    private var onThisDayMilestone: Milestone? {
        let calendar = Calendar.current
        let today = calendar.dateComponents([.day, .month], from: .now)
        let currentYear = calendar.component(.year, from: .now)
        return milestones.first { milestone in
            let comps = calendar.dateComponents([.day, .month, .year], from: milestone.date)
            return comps.day == today.day && comps.month == today.month && comps.year != currentYear
        }
    }

    private func onThisDayCard(_ milestone: Milestone) -> some View {
        let yearsAgo = Calendar.current.component(.year, from: .now) - Calendar.current.component(.year, from: milestone.date)
        return VStack(alignment: .leading, spacing: 8) {
            Text("Op deze dag")
                .font(.caption)
                .textCase(.uppercase)
                .foregroundStyle(Theme.textSecondary)
            Text(milestone.title)
                .font(Theme.cardTitleFont)
                .foregroundStyle(Theme.textPrimary)
            Text("\(yearsAgo) jaar geleden. Kijk hoe ver je sindsdien gekomen bent.")
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }

    private var addMomentButton: some View {
        Button {
            showAddMilestone = true
        } label: {
            Label("Voeg een moment toe", systemImage: "plus")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Theme.accent)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .padding(.top, 4)
    }
}

#Preview {
    TodayView()
        .modelContainer(for: [Milestone.self, Dream.self, Letter.self, WealthEntry.self, UserProfile.self], inMemory: true)
}
