//
//  Plant.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 21.05.26.
//

import Foundation

struct Plant: Codable, Identifiable {
    let id: UUID
    let type: String
    var pot: String?
    var background: String?
    var momentCount: Int
    var lastUpdated: Date
    
    init(
        id: UUID = UUID(),
        type: String,
        pot: String? = nil,
        background: String? = nil,
        momentCount: Int = 0
    ) {
        self.id = id
        self.type = type
        self.pot = pot
        self.background = background
        self.momentCount = momentCount
        self.lastUpdated = Date()
    }
}
