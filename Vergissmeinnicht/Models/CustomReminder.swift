//
//  CustomReminder.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 21.05.26.
//

import Foundation

/// Eine vom Nutzer frei definierte Erinnerung zu einer Beziehung
struct CustomReminder: Identifiable, Equatable {
    let id: UUID
    var date: Date
    var label: String
    
    /// Gibt an, ob für diese Erinnerung noch eine Benachrichtigung geplant werden soll
    var isActive: Bool
    
    init(
        id: UUID = UUID(),
        date: Date,
        label: String,
        isActive: Bool = true
    ) {
        self.id = id
        self.date = date
        self.label = label
        self.isActive = isActive
    }
}
