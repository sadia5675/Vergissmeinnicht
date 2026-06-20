//
//  Hint.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 21.05.26.
//

import Foundation

struct Hint: Identifiable {
    let id: UUID
    var relationshipStatus: RelationshipStatus
    var displayContent: String
    var prefilledMessage: String?
    var sourceMoment: Moment?
    var phoneNumber: String
    var actionButtonText: String?
    
    init(
        id: UUID = UUID(),
        relationshipStatus: RelationshipStatus,
        displayContent: String,
        prefilledMessage: String? = nil,
        sourceMoment: Moment? = nil,
        phoneNumber: String,
        actionButtonText: String? = "Nachricht schreiben"
    ) {
        self.id = id
        self.relationshipStatus = relationshipStatus
        self.displayContent = displayContent
        self.prefilledMessage = prefilledMessage
        self.sourceMoment = sourceMoment
        self.phoneNumber = phoneNumber
        self.actionButtonText = actionButtonText
    }
    
}
