//
//  InteractionType.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 21.05.26.
//

import Foundation

/// Beschreibt die Art einer Interaktion
/// 
/// Kann sowohl vordefiniert als auch vom Nutzer frei erstellt werden
struct InteractionType: Codable, Identifiable, Hashable {
    let id: UUID
    var name: String
    var sfSymbol: String
    
    init(
        id: UUID = UUID(),
        name: String,
        sfSymbol: String
    ) {
        self.id = id
        self.name = name
        self.sfSymbol = sfSymbol
    }
    
    /// Von der App mitgelieferte Standard-Interaktionstypen
    static let predefined: [InteractionType] = [
           InteractionType(name: "Nachricht", sfSymbol: "bubble.right"),
           InteractionType(name: "Anruf", sfSymbol: "phone"),
           InteractionType(name: "Video-Anruf", sfSymbol: "video"),
           InteractionType(name: "Treffen", sfSymbol: "person.2"),
       ]
    
}
