//
//  DreamsView.swift
//  LifeReflectionApp
//

import SwiftUI
import SwiftData

struct DreamsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Dream.dateAdded) private var dreams: [Dream]
    @State private var showAdd = false

    private var fulfilledCount: Int { dreams.filter(\.isFulfilled).count }

    var body: some View {
        NavigationStack {
            Group {
                if dreams.isEmpty {
                    ContentUnavailableView(
                        "Nog geen dromen",
                        systemImage: "sparkles",
                        description: Text("Schrijf op waar je van droomt. Over een paar jaar kijk je hier met verwondering naar terug.")
                    )
                } else {
                    List {
                        Section {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("\(fulfilledCount) van je \(dreams.count) \(dreams.count == 1 ? "droom is" : "dromen zijn") werkelijkheid geworden")
                                    .font(Theme.cardTitleFont)
                                    .foregroundStyle(Theme.textPrimary)
                                if fulfilledCount > 0 {
                                    Text("Wat ooit een droom was, is nu je normale leven.")
                                        .font(Theme.quoteFont)
                                        .foregroundStyle(Theme.accent)
                                }
                            }
                            .padding(.vertical, 6)
                        }

                        Section {
                            ForEach(dreams) { dream in
                                DreamRow(dream: dream)
                            }
                            .onDelete { offsets in
                                for index in offsets {
                                    modelContext.delete(dreams[index])
                                }
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .background(Theme.background.ignoresSafeArea())
            .navigationTitle("Dromen")
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
                AddDreamView()
            }
        }
    }
}

private struct DreamRow: View {
    let dream: Dream

    var body: some View {
        HStack(spacing: 14) {
            Button {
                withAnimation(.spring(duration: 0.4)) {
                    dream.isFulfilled.toggle()
                    dream.fulfilledDate = dream.isFulfilled ? .now : nil
                }
            } label: {
                Image(systemName: dream.isFulfilled ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(dream.isFulfilled ? Theme.accent : Theme.textSecondary)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                Text(dream.text)
                    .font(.body)
                    .foregroundStyle(Theme.textPrimary)
                if dream.isFulfilled, let date = dream.fulfilledDate {
                    Text("Waargemaakt op \(date.formatted(date: .abbreviated, time: .omitted))")
                        .font(.caption)
                        .foregroundStyle(Theme.accent)
                } else {
                    Text("Opgeschreven op \(dream.dateAdded.formatted(date: .abbreviated, time: .omitted))")
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    DreamsView()
        .modelContainer(for: [Dream.self], inMemory: true)
}
