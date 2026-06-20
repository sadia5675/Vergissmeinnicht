//
//  Relationship.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 21.05.26.
//

import Foundation

struct Relationship: Identifiable {
    let id: UUID
    var name: String
    var phoneNumber: String
    var birthDate: Date?
    var createdDate: Date
    var lastInteractionDate: Date?
    
    var plant: Plant
    var careRhythm: CareRhythm
    var moments: [Moment]
    var customReminders: [CustomReminder]
    
    var status: RelationshipStatus {

        let days =
            getDaysSinceLastContact()

        if days >= careRhythm.interval * 2 {
            return .missesYou
        }

        if days >= careRhythm.interval {
            return .needsCare
        }

        return .blooming
    }
    
    init(
        id: UUID = UUID(),
        name: String,
        phoneNumber: String,
        birthDate: Date? = nil,
        plant: Plant,
        careRhythm: CareRhythm,
        moments: [Moment] = [],
        customReminders: [CustomReminder] = []
    ) {
        self.id = id
        self.name = name
        self.phoneNumber = phoneNumber
        self.birthDate = birthDate
        self.createdDate = Date.now
        self.lastInteractionDate = Date.now
        self.plant = plant
        self.careRhythm = careRhythm
        self.moments = moments
        self.customReminders = customReminders
    }
    
    // reine Daten-Berechnungen
    func getDaysSinceLastContact() -> Int {
        guard let lastDate = lastInteractionDate else { return Int.max }
        return careRhythm.daysSince(lastDate)
    }
    
    func isOverdue() -> Bool {
        guard let lastDate = lastInteractionDate else { return true }
        return careRhythm.isOverdue(lastInteraction: lastDate)
    }
}
