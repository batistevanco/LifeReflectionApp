//
//  LettersView.swift
//  LifeReflectionApp
//

import SwiftUI
import SwiftData

struct LettersView: View {
    @Query(sort: \Letter.openDate) private var letters: [Letter]
    @State private var showWrite = false

    var body: some View {
        NavigationStack {
            Group {
                if letters.isEmpty {
                    ContentUnavailableView(
                        "Nog geen brieven",
                        systemImage: "envelope",
                        description: Text("Schrijf een brief aan je toekomstige zelf. Een cadeau dat jaren later aankomt.")
                    )
                } else {
                    List {
                        ForEach(letters) { letter in
                            NavigationLink(value: letter) {
                                LetterRow(letter: letter)
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .background(Theme.background.ignoresSafeArea())
            .navigationTitle("Brieven")
            .navigationDestination(for: Letter.self) { letter in
                LetterDetailView(letter: letter)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showWrite = true
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
            .sheet(isPresented: $showWrite) {
                WriteLetterView()
            }
        }
    }
}

private struct LetterRow: View {
    let letter: Letter

    private var status: (icon: String, text: String, color: Color) {
        if letter.isOpened {
            return ("envelope.open", "Gelezen", Theme.textSecondary)
        } else if letter.openDate <= .now {
            return ("envelope.badge", "Klaar om te openen", Theme.accent)
        } else {
            return ("lock", "Opent op \(letter.openDate.formatted(date: .abbreviated, time: .omitted))", Theme.textSecondary)
        }
    }

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: status.icon)
                .font(.title3)
                .foregroundStyle(status.color)
                .frame(width: 32)
            VStack(alignment: .leading, spacing: 4) {
                Text("Geschreven op \(letter.dateWritten.formatted(date: .abbreviated, time: .omitted))")
                    .font(.headline)
                    .foregroundStyle(Theme.textPrimary)
                Text(status.text)
                    .font(.caption)
                    .foregroundStyle(status.color)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    LettersView()
        .modelContainer(for: [Letter.self], inMemory: true)
}
