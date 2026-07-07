//
//  Models.swift
//  LifeReflectionApp
//

import Foundation
import SwiftData

@Model
final class Milestone {
    var title: String
    var date: Date
    var photoData: Data?
    var feelingText: String
    var whyText: String
    var location: String?
    var oldSelfQuote: String?

    init(
        title: String,
        date: Date = .now,
        photoData: Data? = nil,
        feelingText: String = "",
        whyText: String = "",
        location: String? = nil,
        oldSelfQuote: String? = nil
    ) {
        self.title = title
        self.date = date
        self.photoData = photoData
        self.feelingText = feelingText
        self.whyText = whyText
        self.location = location
        self.oldSelfQuote = oldSelfQuote
    }
}

@Model
final class Dream {
    var text: String
    var dateAdded: Date
    var isFulfilled: Bool
    var fulfilledDate: Date?

    init(text: String, dateAdded: Date = .now, isFulfilled: Bool = false, fulfilledDate: Date? = nil) {
        self.text = text
        self.dateAdded = dateAdded
        self.isFulfilled = isFulfilled
        self.fulfilledDate = fulfilledDate
    }
}

@Model
final class Letter {
    var text: String
    var dateWritten: Date
    var openDate: Date
    var isOpened: Bool

    init(text: String, dateWritten: Date = .now, openDate: Date, isOpened: Bool = false) {
        self.text = text
        self.dateWritten = dateWritten
        self.openDate = openDate
        self.isOpened = isOpened
    }
}

@Model
final class WealthEntry {
    var date: Date
    var amount: Double

    init(date: Date = .now, amount: Double) {
        self.date = date
        self.amount = amount
    }
}

@Model
final class UserProfile {
    var birthYear: Int
    var name: String?
    var onboardingComplete: Bool

    init(birthYear: Int = Calendar.current.component(.year, from: .now) - 20, name: String? = nil, onboardingComplete: Bool = false) {
        self.birthYear = birthYear
        self.name = name
        self.onboardingComplete = onboardingComplete
    }
}
