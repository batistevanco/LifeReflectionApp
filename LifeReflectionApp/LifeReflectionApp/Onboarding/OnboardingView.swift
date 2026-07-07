//
//  OnboardingView.swift
//  LifeReflectionApp
//

import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]

    @State private var step = 0
    @State private var birthYear = Calendar.current.component(.year, from: .now) - 20
    @State private var proudThings: [String] = ["", "", ""]
    @State private var dreamTexts: [String] = ["", ""]
    @State private var currentWealth = ""

    private let totalSteps = 6

    var body: some View {
        VStack(spacing: 0) {
            ProgressView(value: Double(step + 1), total: Double(totalSteps))
                .tint(Theme.accent)
                .padding(.horizontal)
                .padding(.top)

            TabView(selection: $step) {
                welcomeStep.tag(0)
                birthYearStep.tag(1)
                proudThingsStep.tag(2)
                dreamsStep.tag(3)
                wealthStep.tag(4)
                finishStep.tag(5)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: step)
        }
        .background(Theme.background.ignoresSafeArea())
    }

    private var welcomeStep: some View {
        OnboardingStepLayout(
            title: "Welkom",
            subtitle: "\"De app die je eraan herinnert hoe ver je al gekomen bent.\"",
            buttonTitle: "Beginnen"
        ) {
            step = 1
        }
    }

    private var birthYearStep: some View {
        OnboardingStepLayout(
            title: "Over jou",
            subtitle: "In welk jaar ben je geboren?",
            buttonTitle: "Volgende"
        ) {
            step = 2
        } content: {
            Picker("Geboortejaar", selection: $birthYear) {
                ForEach((Calendar.current.component(.year, from: .now) - 90)...(Calendar.current.component(.year, from: .now) - 5), id: \.self) { year in
                    Text(String(year)).tag(year)
                }
            }
            .pickerStyle(.wheel)
        }
    }

    private var proudThingsStep: some View {
        OnboardingStepLayout(
            title: "Waar ben je trots op?",
            subtitle: "Noem 3 dingen waar je vandaag trots op bent.",
            buttonTitle: "Volgende"
        ) {
            step = 3
        } content: {
            VStack(spacing: 12) {
                ForEach(0..<3, id: \.self) { i in
                    TextField("Bijvoorbeeld: Mijn diploma behaald", text: $proudThings[i])
                        .textFieldStyle(.roundedBorder)
                }
            }
        }
    }

    private var dreamsStep: some View {
        OnboardingStepLayout(
            title: "Je dromen",
            subtitle: "Wat waren je grootste dromen vroeger?",
            buttonTitle: "Volgende"
        ) {
            step = 4
        } content: {
            VStack(spacing: 12) {
                ForEach(0..<2, id: \.self) { i in
                    TextField("Bijvoorbeeld: Een eigen bedrijf starten", text: $dreamTexts[i])
                        .textFieldStyle(.roundedBorder)
                }
            }
        }
    }

    private var wealthStep: some View {
        OnboardingStepLayout(
            title: "Vermogen (optioneel)",
            subtitle: "Wil je je huidige spaargeld invullen? Dit is volledig optioneel en blijft alleen op je toestel.",
            buttonTitle: "Volgende"
        ) {
            step = 5
        } content: {
            TextField("Bijvoorbeeld: 5000", text: $currentWealth)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
        }
    }

    private var finishStep: some View {
        OnboardingStepLayout(
            title: "Helemaal klaar",
            subtitle: "Je bent al verder dan je denkt. Laten we het bewijzen.",
            buttonTitle: "Start"
        ) {
            completeOnboarding()
        }
    }

    private func completeOnboarding() {
        for text in proudThings where !text.trimmingCharacters(in: .whitespaces).isEmpty {
            modelContext.insert(Milestone(title: text))
        }
        for text in dreamTexts where !text.trimmingCharacters(in: .whitespaces).isEmpty {
            modelContext.insert(Dream(text: text))
        }
        if let amount = Double(currentWealth.replacingOccurrences(of: ",", with: ".")), amount > 0 {
            modelContext.insert(WealthEntry(amount: amount))
        }

        if let profile = profiles.first {
            profile.birthYear = birthYear
            profile.onboardingComplete = true
        } else {
            let profile = UserProfile(birthYear: birthYear, onboardingComplete: true)
            modelContext.insert(profile)
        }

        NotificationManager.scheduleWeeklyReview()
    }
}

private struct OnboardingStepLayout<Content: View>: View {
    let title: String
    let subtitle: String
    let buttonTitle: String
    let action: () -> Void
    @ViewBuilder var content: () -> Content

    init(
        title: String,
        subtitle: String,
        buttonTitle: String,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content = { EmptyView() }
    ) {
        self.title = title
        self.subtitle = subtitle
        self.buttonTitle = buttonTitle
        self.action = action
        self.content = content
    }

    var body: some View {
        VStack(spacing: 28) {
            Spacer()
            Text(title)
                .font(Theme.heroFont)
                .foregroundStyle(Theme.textPrimary)
                .multilineTextAlignment(.center)
            Text(subtitle)
                .font(.body)
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            content()
                .padding(.horizontal, 32)
            Spacer()
            Button(action: action) {
                Text(buttonTitle)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Theme.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    OnboardingView()
        .modelContainer(for: [Milestone.self, Dream.self, Letter.self, WealthEntry.self, UserProfile.self], inMemory: true)
}
