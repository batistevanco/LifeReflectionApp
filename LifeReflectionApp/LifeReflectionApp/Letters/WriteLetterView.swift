//
//  WriteLetterView.swift
//  LifeReflectionApp
//

import SwiftUI
import SwiftData

struct WriteLetterView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var text = ""
    @State private var openDate = Calendar.current.date(byAdding: .year, value: 1, to: .now) ?? .now

    private let presets: [(label: String, years: Int)] = [
        ("Over 1 jaar", 1),
        ("Over 3 jaar", 3),
        ("Over 5 jaar", 5),
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section("Aan je toekomstige zelf") {
                    TextField("Beste toekomstige ik...", text: $text, axis: .vertical)
                        .lineLimit(8...16)
                }

                Section("Wanneer mag je dit lezen?") {
                    HStack {
                        ForEach(presets, id: \.years) { preset in
                            Button(preset.label) {
                                openDate = Calendar.current.date(byAdding: .year, value: preset.years, to: .now) ?? .now
                            }
                            .buttonStyle(.bordered)
                            .tint(Theme.accent)
                            .font(.caption)
                        }
                    }
                    DatePicker("Open-datum", selection: $openDate, in: Date.now..., displayedComponents: .date)
                }
            }
            .navigationTitle("Nieuwe brief")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuleer") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Verzegel") {
                        let letter = Letter(text: text, openDate: openDate)
                        modelContext.insert(letter)
                        NotificationManager.scheduleLetterNotification(openDate: openDate)
                        dismiss()
                    }
                    .disabled(text.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

#Preview {
    WriteLetterView()
        .modelContainer(for: [Letter.self], inMemory: true)
}
