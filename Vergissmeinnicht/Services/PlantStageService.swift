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
    
    func stage(
        for momentCount: Int
    ) -> Int {

        switch momentCount {

        case 0...2:
            return 0

        case 3...5:
            return 1

        case 6...8:
            return 2

        default:
            return 3
        }
    }
    
    func calculateStage(
        for relationship: Relationship
    ) -> Int {

        let count =
            currentMomentCount(
                for: relationship
            )

        return stage(
            for: count
        )
    }
    
    func currentMomentCount(
        for relationship: Relationship
    ) -> Int {

        var count =
            relationship.plant.momentCount

        guard let lastDate =
            relationship.lastInteractionDate
        else {
            return count
        }

        let daysSince =
            relationship.careRhythm.daysSince(
                lastDate
            )

        let interval =
            relationship.careRhythm.interval

        let overdue =
            daysSince / interval

        for _ in 0..<overdue {

            switch count {

            case 9:
                count = 8

            case 6...8:
                count = 5

            case 3...5:
                count = 2 

            default:
                count = 0
            }
        }

        return count
    }
}
