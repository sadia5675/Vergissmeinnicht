//
//  PlantStageService.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 09.06.26.
//

import Foundation

@MainActor
class PlantStageService {
    static let shared = PlantStageService()
    
    func calculateStage(
        for relationship: Relationship
    ) -> Int {

        var stage =
            relationship.plant.growthStage

        guard let lastDate =
            relationship.lastInteractionDate
        else {
            return stage
        }

        let daysSince =
            relationship.careRhythm.daysSince(
                lastDate
            )

        let interval =
            relationship.careRhythm.interval

        if daysSince >= interval {

            let overdueMultiplier =
                daysSince / interval

            stage = max(
                0,
                stage - overdueMultiplier
            )
        }

        return stage
    }
}
