//
//  InteractionType.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 21.05.26.
//

import Foundation

struct InteractionType: Codable, Identifiable, Hashable {
    let id: UUID
    var name: String
    var sfSymbol: String
    var isCustom: Bool
    
    init(id: UUID = UUID(), name: String, sfSymbol: String, isCustom: Bool = false) {
        self.id = id
        self.name = name
        self.sfSymbol = sfSymbol
        self.isCustom = isCustom
    }
}

