//
//  Plant.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 21.05.26.
//

import Foundation

/// Die visuelle Repräsentation einer Beziehung als wachsende Pflanze
///
/// type, pot  und background speichern jeweils nur den Namen des Bild-Assets
/// Die eigentlichen Grafiken werden über den ImageService aus dem Asset-Bundle geladen
struct Plant: Codable, Identifiable {
    let id: UUID
    
    /// Name des Pflanzentyps
    var type: String
    
    /// Name des gewählten Topfs, falls vorhanden
    var pot: String?
    
    /// Name des gewählten Hintergrunds, falls vorhanden
    var background: String?
    
    /// Anzahl der Momente, die das Wachstum der Pflanze bestimmen (0–9)
    var momentCount: Int
    
    var lastUpdated: Date
    
    init(
        id: UUID = UUID(),
        type: String,
        pot: String? = nil,
        background: String? = nil,
        momentCount: Int = 0,
        lastUpdated: Date? = nil
    ) {
        self.id = id
        self.type = type
        self.pot = pot
        self.background = background
        self.momentCount = momentCount
        self.lastUpdated = lastUpdated ?? Date()
    }
}
