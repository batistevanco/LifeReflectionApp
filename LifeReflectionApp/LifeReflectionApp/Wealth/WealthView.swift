//
//  WealthView.swift
//  LifeReflectionApp
//

import SwiftUI
import SwiftData
import Charts

struct WealthView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \WealthEntry.date) private var entries: [WealthEntry]
    @State private var showAdd = false

    var body: some View {
        NavigationStack {
            Group {
                if entries.isEmpty {
                    ContentUnavailableView(
                        "Nog geen gegevens",
                        systemImage: "chart.line.uptrend.xyaxis",
                        description: Text("Voeg af en toe je spaargeld toe en zie je groei door de jaren heen. Alles blijft op je toestel.")
                    )
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            growthSummary
                            chart
                            entriesList
                        }
                        .padding()
                    }
                }
            }
            .background(Theme.background.ignoresSafeArea())
            .navigationTitle("Vermogen")
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
                AddWealthEntryView()
            }
        }
    }

    private var growthSummary: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Nu")
                .font(.caption)
                .textCase(.uppercase)
                .foregroundStyle(Theme.textSecondary)
            Text(entries.last?.amount ?? 0, format: .currency(code: "EUR").precision(.fractionLength(0)))
                .font(Theme.heroFont)
                .foregroundStyle(Theme.textPrimary)
            if entries.count >= 2 {
                let diff = entries.last!.amount - entries.first!.amount
                if diff > 0 {
                    Text("📈 +\(diff.formatted(.currency(code: "EUR").precision(.fractionLength(0)))) sinds je eerste invoer")
                        .font(.subheadline)
                        .foregroundStyle(Theme.accent)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }

    private var chart: some View {
        Chart(entries) { entry in
            LineMark(
                x: .value("Datum", entry.date),
                y: .value("Bedrag", entry.amount)
            )
            .foregroundStyle(Theme.accent)
            .interpolationMethod(.catmullRom)

            AreaMark(
                x: .value("Datum", entry.date),
                y: .value("Bedrag", entry.amount)
            )
            .foregroundStyle(
                LinearGradient(
                    colors: [Theme.accent.opacity(0.25), .clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .interpolationMethod(.catmullRom)

            PointMark(
                x: .value("Datum", entry.date),
                y: .value("Bedrag", entry.amount)
            )
            .foregroundStyle(Theme.accent)
        }
        .frame(height: 220)
        .cardStyle()
    }

    private var entriesList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Alle invoeren")
                .font(.caption)
                .textCase(.uppercase)
                .foregroundStyle(Theme.textSecondary)
            ForEach(entries.reversed()) { entry in
                HStack {
                    Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                    Spacer()
                    Text(entry.amount, format: .currency(code: "EUR").precision(.fractionLength(0)))
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(Theme.textPrimary)
                    Button(role: .destructive) {
                        modelContext.delete(entry)
                    } label: {
                        Image(systemName: "trash")
                            .font(.caption)
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
                .padding(.vertical, 2)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }
}

struct AddWealthEntryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var amount = ""
    @State private var date = Date.now

    var body: some View {
        NavigationStack {
            Form {
                Section("Hoeveel heb je nu?") {
                    TextField("Bedrag in euro", text: $amount)
                        .keyboardType(.decimalPad)
                    DatePicker("Datum", selection: $date, in: ...Date.now, displayedComponents: .date)
                }
            }
            .navigationTitle("Nieuwe invoer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuleer") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Bewaar") {
                        if let value = Double(amount.replacingOccurrences(of: ",", with: ".")) {
                            modelContext.insert(WealthEntry(date: date, amount: value))
                        }
                        dismiss()
                    }
                    .disabled(Double(amount.replacingOccurrences(of: ",", with: ".")) == nil)
                }
            }
        }
    }
}

#Preview {
    WealthView()
        .modelContainer(for: [WealthEntry.self], inMemory: true)
}
