//
//  Moment.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 21.05.26.
//

import Foundation

struct Moment: Codable, Identifiable {
    let id: UUID
    var relationshipIds: [UUID]
    var date: Date
    var type: InteractionType
    var notes: String?
    var photoPath: String?
    
    init(
        id: UUID = UUID(),
        relationshipIds: [UUID],
        date: Date = Date(),
        type: InteractionType,
        notes: String? = nil,
        photoPath: String? = nil,
    ) {
        self.id = id
        self.relationshipIds = relationshipIds
        self.date = date
        self.type = type
        self.notes = notes
        self.photoPath = photoPath
    }
    
}
