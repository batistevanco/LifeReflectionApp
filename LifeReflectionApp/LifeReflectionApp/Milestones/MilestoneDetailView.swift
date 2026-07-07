//
//  MilestoneDetailView.swift
//  LifeReflectionApp
//

import SwiftUI
import SwiftData

struct MilestoneDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    let milestone: Milestone

    @State private var showEdit = false
    @State private var showDeleteConfirmation = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let data = milestone.photoData, let image = UIImage(data: data) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 280)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(milestone.title)
                        .font(Theme.heroFont)
                        .foregroundStyle(Theme.textPrimary)
                    HStack(spacing: 12) {
                        Label(milestone.date.formatted(date: .long, time: .omitted), systemImage: "calendar")
                        if let location = milestone.location, !location.isEmpty {
                            Label(location, systemImage: "mappin.and.ellipse")
                        }
                    }
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
                }

                if !milestone.feelingText.isEmpty {
                    detailBlock(title: "Hoe voelde je je?", text: milestone.feelingText)
                }
                if !milestone.whyText.isEmpty {
                    detailBlock(title: "Waarom was dit belangrijk?", text: milestone.whyText)
                }
                if let quote = milestone.oldSelfQuote, !quote.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("De oude jij")
                            .font(.caption)
                            .textCase(.uppercase)
                            .foregroundStyle(Theme.textSecondary)
                        Text("\"\(quote)\"")
                            .font(Theme.quoteFont)
                            .foregroundStyle(Theme.accent)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .cardStyle()
                }
            }
            .padding()
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button {
                        showEdit = true
                    } label: {
                        Label("Bewerken", systemImage: "pencil")
                    }
                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        Label("Verwijderen", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showEdit) {
            AddMilestoneView(milestone: milestone)
        }
        .confirmationDialog("Dit moment verwijderen?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
            Button("Verwijderen", role: .destructive) {
                modelContext.delete(milestone)
                dismiss()
            }
        }
    }

    private func detailBlock(title: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .textCase(.uppercase)
                .foregroundStyle(Theme.textSecondary)
            Text(text)
                .font(.body)
                .foregroundStyle(Theme.textPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }
}
