//
//  CareRhythm.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 21.05.26.
//

import Foundation

/// Definiert, in welchem Rhythmus eine Beziehung gepflegt werden soll
struct CareRhythm: Identifiable {
    
    let id: UUID
    
    /// Gewünschter Abstand zwischen zwei Kontakten, in Tagen
    var interval: Int
    
    /// Zeitpunkt, zu dem die nächste sanfte Erinnerung ausgelöst werden soll
    var nextReminderDate: Date
    
    init(
        id: UUID = UUID(),
        interval: Int,
        nextReminderDate: Date? = nil 
    ) {
        self.id = id
        self.interval = interval
        self.nextReminderDate = nextReminderDate ?? Calendar.current.date(
            byAdding: .day, value: interval, to: Date()
        )!
    }
    
    /// Berechnet die Anzahl vollständiger Tage zwischen dem übergebenen Datum und heute
    func daysSince(_ date: Date) -> Int {
        let calendar = Calendar.current
        
        // Jeweils auf Tagesbeginn normalisieren
        let startOfLast = calendar.startOfDay(for: date)
        let startOfToday = calendar.startOfDay(for: Date())
        
        let components = calendar.dateComponents([.day], from: startOfLast, to: startOfToday)
        
        return components.day ?? 0
    }
    
    /// Gibt an, ob seit dem letzten Kontakt mehr Tage vergangen sind, als das Intervall vorsieht
    func isOverdue(lastInteraction: Date) -> Bool {
        let daysSince = daysSince(lastInteraction)
        return daysSince >= interval
    }
    /// Vordefinierte Intervalle in Tagen
    static let presets: [Int] = [3, 7, 14, 30]
}
