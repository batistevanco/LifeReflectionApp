//
//  AddMilestoneView.swift
//  LifeReflectionApp
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddMilestoneView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var milestone: Milestone?

    @State private var title = ""
    @State private var date = Date.now
    @State private var feelingText = ""
    @State private var whyText = ""
    @State private var location = ""
    @State private var oldSelfQuote = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var photoData: Data?

    private var isEditing: Bool { milestone != nil }

    var body: some View {
        NavigationStack {
            Form {
                Section("Het moment") {
                    TextField("Titel", text: $title)
                    DatePicker("Datum", selection: $date, in: ...Date.now, displayedComponents: .date)
                }

                Section("Foto") {
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        if let photoData, let image = UIImage(data: photoData) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: 160)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        } else {
                            Label("Kies een foto", systemImage: "photo")
                        }
                    }
                }

                Section("Reflectie") {
                    TextField("Hoe voelde je je?", text: $feelingText, axis: .vertical)
                        .lineLimit(2...4)
                    TextField("Waarom was dit belangrijk?", text: $whyText, axis: .vertical)
                        .lineLimit(2...4)
                }

                Section("Optioneel") {
                    TextField("Locatie", text: $location)
                    TextField("Dit zou mijn jongere zelf niet geloven omdat...", text: $oldSelfQuote, axis: .vertical)
                        .lineLimit(2...4)
                }
            }
            .navigationTitle(isEditing ? "Moment bewerken" : "Nieuw moment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuleer") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Bewaar") { save() }
                        .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onChange(of: selectedPhoto) {
                Task {
                    if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                        photoData = data
                    }
                }
            }
            .onAppear {
                if let milestone {
                    title = milestone.title
                    date = milestone.date
                    feelingText = milestone.feelingText
                    whyText = milestone.whyText
                    location = milestone.location ?? ""
                    oldSelfQuote = milestone.oldSelfQuote ?? ""
                    photoData = milestone.photoData
                }
            }
        }
    }

    private func save() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespaces)
        if let milestone {
            milestone.title = trimmedTitle
            milestone.date = date
            milestone.feelingText = feelingText
            milestone.whyText = whyText
            milestone.location = location.isEmpty ? nil : location
            milestone.oldSelfQuote = oldSelfQuote.isEmpty ? nil : oldSelfQuote
            milestone.photoData = photoData
        } else {
            let new = Milestone(
                title: trimmedTitle,
                date: date,
                photoData: photoData,
                feelingText: feelingText,
                whyText: whyText,
                location: location.isEmpty ? nil : location,
                oldSelfQuote: oldSelfQuote.isEmpty ? nil : oldSelfQuote
            )
            modelContext.insert(new)
        }
        dismiss()
    }
}

#Preview {
    AddMilestoneView()
        .modelContainer(for: [Milestone.self], inMemory: true)
}
