//
//  Relationship.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 21.05.26.
//

import Foundation

/// Repräsentiert eine Beziehung im Garten
///
/// Eine Relationship bündelt alle Informationen zu einer Person:  ihre zugehörige Pflanze, den gewünschten Pflegerhythmus, optionale Erinnerungen sowie den Status ihrer Pflege
struct Relationship: Identifiable {
    let id: UUID
    var name: String
    var phoneNumber: String
    var birthDate: Date?
    
    /// Nur für interne Berechnungen (Status, Erinnerungen)
    var lastInteractionDate: Date
    
    var isResting: Bool = false
    
    /// Eingefrorener Tage-Wert, solange isResting == true
    var pausedDaysSince: Int?
    
    /// Datum des letzten echten Moments, nur für die Anzeige
    var lastMomentDate: Date?
    
    var plant: Plant
    var careRhythm: CareRhythm
    var moments: [Moment]
    var customReminders: [CustomReminder]
    
    /// Der aktuelle Pflegezustand der Beziehung, ergibt sich aus dem Pflegeintervall und den vergangenen Tagen seit dem letzten Kontakt
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
        isResting: Bool = false,
        pausedDaysSince: Int? = nil,
        plant: Plant,
        careRhythm: CareRhythm,
        moments: [Moment] = [],
        customReminders: [CustomReminder] = []
    ) {
        self.id = id
        self.name = name
        self.phoneNumber = phoneNumber
        self.birthDate = birthDate
        self.lastInteractionDate = Date.now
        self.isResting = isResting
        self.pausedDaysSince = pausedDaysSince
        self.lastMomentDate = nil 
        self.plant = plant
        self.careRhythm = careRhythm
        self.moments = moments
        self.customReminders = customReminders
    }
    
    /// Berechnet die Anzahl der Tage seit dem letzten Kontakt
    ///
    /// Ruht die Beziehung, wird stattdessen der eingefrorene Wert pausedDaysSince zurückgegeben, damit sich der Status während der Ruhephase nicht verändert
    func getDaysSinceLastContact() -> Int {
        if isResting,
           let pausedDaysSince {
            return pausedDaysSince
        }
        return careRhythm.daysSince(lastInteractionDate)
    }
    
    /// Gibt an, ob die Beziehung laut Pflegeintervall überfällig ist
    func isOverdue() -> Bool {
        return careRhythm.isOverdue(lastInteraction: lastInteractionDate)
    }
}
