//
//  Hint.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 21.05.26.
//

import Foundation

/// Ein sanfter, kontextbezogener Hinweis zu einer Beziehung, der im Garten oder in der Detailansicht angezeigt wird
struct Hint: Identifiable {

    let id: UUID
    let relationship: Relationship
    let relationshipStatus: RelationshipStatus
    let displayContent: String
    
    /// Vorausgefüllter Nachrichtentext, falls der Hint zu einer Kontaktaufnahme vorschlagt
    let prefilledMessage: String?
    
    /// Der Moment, auf den sich der Hint inhaltlich bezieht
    let sourceMoment: Moment?

    init(
        id: UUID = UUID(),
        relationship: Relationship,
        relationshipStatus: RelationshipStatus,
        displayContent: String,
        prefilledMessage: String? = nil,
        sourceMoment: Moment? = nil
    ) {
        self.id = id
        self.relationship = relationship
        self.relationshipStatus = relationshipStatus
        self.displayContent = displayContent
        self.prefilledMessage = prefilledMessage
        self.sourceMoment = sourceMoment
    }
}
