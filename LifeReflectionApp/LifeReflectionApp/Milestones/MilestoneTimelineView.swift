//
//  MilestoneTimelineView.swift
//  LifeReflectionApp
//

import SwiftUI
import SwiftData

struct MilestoneTimelineView: View {
    @Query(sort: \Milestone.date, order: .reverse) private var milestones: [Milestone]
    @State private var showAdd = false

    private var groupedByYear: [(year: Int, items: [Milestone])] {
        let groups = Dictionary(grouping: milestones) {
            Calendar.current.component(.year, from: $0.date)
        }
        return groups.keys.sorted(by: >).map { (year: $0, items: groups[$0] ?? []) }
    }

    var body: some View {
        NavigationStack {
            Group {
                if milestones.isEmpty {
                    ContentUnavailableView(
                        "Nog geen momenten",
                        systemImage: "clock.arrow.circlepath",
                        description: Text("Voeg je eerste mijlpaal toe en bouw je eigen verhaal op.")
                    )
                } else {
                    List {
                        ForEach(groupedByYear, id: \.year) { group in
                            Section {
                                ForEach(group.items) { milestone in
                                    NavigationLink(value: milestone) {
                                        MilestoneRow(milestone: milestone)
                                    }
                                }
                            } header: {
                                Text(String(group.year))
                                    .font(Theme.cardTitleFont)
                                    .foregroundStyle(Theme.textPrimary)
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .background(Theme.background.ignoresSafeArea())
            .navigationTitle("Tijdlijn")
            .navigationDestination(for: Milestone.self) { milestone in
                MilestoneDetailView(milestone: milestone)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAdd) {
                AddMilestoneView()
            }
        }
    }
}

private struct MilestoneRow: View {
    let milestone: Milestone

    var body: some View {
        HStack(spacing: 14) {
            if let data = milestone.photoData, let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 52, height: 52)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            } else {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Theme.accent.opacity(0.15))
                    .frame(width: 52, height: 52)
                    .overlay {
                        Image(systemName: "star")
                            .foregroundStyle(Theme.accent)
                    }
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(milestone.title)
                    .font(.headline)
                    .foregroundStyle(Theme.textPrimary)
                Text(milestone.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    MilestoneTimelineView()
        .modelContainer(for: [Milestone.self, Dream.self, Letter.self, WealthEntry.self, UserProfile.self], inMemory: true)
}
