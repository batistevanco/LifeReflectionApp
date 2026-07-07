//
//  LetterDetailView.swift
//  LifeReflectionApp
//

import SwiftUI
import SwiftData

struct LetterDetailView: View {
    let letter: Letter

    private var isUnlocked: Bool { letter.openDate <= .now }

    var body: some View {
        Group {
            if isUnlocked {
                openedLetter
            } else {
                lockedLetter
            }
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if isUnlocked && !letter.isOpened {
                letter.isOpened = true
            }
        }
    }

    private var openedLetter: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Een brief van jezelf")
                        .font(Theme.heroFont)
                        .foregroundStyle(Theme.textPrimary)
                    Text("Geschreven op \(letter.dateWritten.formatted(date: .long, time: .omitted))")
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                }

                Text(letter.text)
                    .font(Font.system(.body, design: .serif))
                    .foregroundStyle(Theme.textPrimary)
                    .lineSpacing(6)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .cardStyle()
            }
            .padding()
        }
    }

    private var lockedLetter: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "lock.circle")
                .font(.system(size: 64))
                .foregroundStyle(Theme.accent)
            Text("Nog even geduld")
                .font(Theme.heroFont)
                .foregroundStyle(Theme.textPrimary)
            Text("Deze brief opent op \(letter.openDate.formatted(date: .long, time: .omitted)).\nNog \(daysRemaining) \(daysRemaining == 1 ? "dag" : "dagen").")
                .font(.body)
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding()
    }

    private var daysRemaining: Int {
        max(Calendar.current.dateComponents([.day], from: .now, to: letter.openDate).day ?? 0, 0)
    }
}
