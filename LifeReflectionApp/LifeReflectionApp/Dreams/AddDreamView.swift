//
//  AddDreamView.swift
//  LifeReflectionApp
//

import SwiftUI
import SwiftData

struct AddDreamView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var text = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Waar droom je van?") {
                    TextField("Bijvoorbeeld: Een eigen huis kopen", text: $text, axis: .vertical)
                        .lineLimit(2...4)
                }
            }
            .navigationTitle("Nieuwe droom")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuleer") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Bewaar") {
                        modelContext.insert(Dream(text: text.trimmingCharacters(in: .whitespaces)))
                        dismiss()
                    }
                    .disabled(text.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddDreamView()
        .modelContainer(for: [Dream.self], inMemory: true)
}
