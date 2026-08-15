//
//  Moment.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 21.05.26.
//

import Foundation

/// Ein einzelner, dokumentierter Interaktions-Moment zwischen dem Nutzer:innen und einer oder mehreren Beziehungen
struct Moment: Codable, Identifiable {
    let id: UUID
    
    /// IDs aller Beziehungen, die an diesem Moment beteiligt waren
    var relationshipIds: [UUID]
    
    var date: Date
    var interactionType: InteractionType
    var notes: String?
    var photoPath: String?
    
    init(
        id: UUID = UUID(),
        relationshipIds: [UUID],
        date: Date = Date(),
        interactionType: InteractionType,
        notes: String? = nil,
        photoPath: String? = nil
    ) {
        self.id = id
        self.relationshipIds = relationshipIds
        self.date = date
        self.interactionType = interactionType
        self.notes = notes
        self.photoPath = photoPath
    }
    
}
