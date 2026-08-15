//
//  PlantStageService.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 09.06.26.
//

import Foundation

/// Berechnet die Wachstumsstufe einer Pflanze aus der Anzahl der Momente
@MainActor
class PlantStageService {
    
    static let shared = PlantStageService()

    
    /// Aktuelle Wachstumsstufe einer Beziehung
    func calculateStage(for relationship: Relationship) -> Int {
        let count = currentMomentCount(for: relationship)
        return stage(for: count)
    }
    
    /// Reduziert die Moment-Anzahl, wenn das Pflegeintervall überschritten wurde
    /// 
    /// Die Pflanze schrumpft wieder, wenn zu lange kein Kontakt stattfand
    func currentMomentCount(for relationship: Relationship) -> Int {

        // Während der Ruhe bleibt die Pflanze unverändert
        if relationship.isResting {
            return relationship.plant.momentCount
        }
        var count = relationship.plant.momentCount
        
        let daysSince = relationship.getDaysSinceLastContact()
        let interval = relationship.careRhythm.interval
        
        // Wie oft wurde das Intervall am Stück überschritten?
        let overdue = daysSince / interval

        // Für jede Überschreitung eine Stufe zurücksetzen
        for _ in 0..<overdue {
            switch count {

            case 9:
                count = 8

            case 6...8:
                count = 5

            case 3...5:
                count = 2

            default:
                count = 0
            }
        }

        return count
    }
    
    /// Übersetzt eine Anzahl von Momenten in eine Wachstumsstufe (0–3)
    func stage(for momentCount: Int) -> Int {
        switch momentCount {

        case 0...2:
            return 0

        case 3...5:
            return 1

        case 6...8:
            return 2

        default:
            return 3
        }
    }
}
