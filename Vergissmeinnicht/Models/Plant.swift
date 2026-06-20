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
    var growthStage: Int
    var lastUpdated: Date
    
    init(
        id: UUID = UUID(),
        type: String,
        pot: String? = nil,
        background: String? = nil,
        growthStage: Int = 0
    ) {
        self.id = id
        self.type = type
        self.pot = pot
        self.background = background
        self.growthStage = growthStage
        self.lastUpdated = Date()
    }
    
    func getMaxStage() -> Int {
        return AppConstants.plantStageCount - 1
    }
    
    mutating func updateStage(_ newStage: Int) {
        self.growthStage = max(0, min(newStage, getMaxStage()))
        self.lastUpdated = Date()
    }
}
