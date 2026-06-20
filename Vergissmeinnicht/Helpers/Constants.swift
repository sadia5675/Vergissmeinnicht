//
//  Constants.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 21.05.26.
//

import Foundation

struct AppConstants {
    // MARK: - Plant Stages
    static let plantStageCount = 4

    // MARK: - Care Rhythm Presets
    static let careRhythmPresets: [Int] = [3, 7, 14, 30]
    
    // MARK: - File Names
    struct FileNames {
        static let relationshipsJSON = "relationships.json"
        static let momentsJSON = "moments.json"
        static let hintsJSON = "hints.json"
        static let photosDirectory = "photos"
    }
    
    // MARK: - Plant Frame Names
   // static func plantFrameName(type: PlantType, stage: Int) -> String {
    //    let stageName = stage < 0 ? 0 : (stage >= plantStageCount ? plantStageCount - 1 : stage)
    //    return "\(type.rawValue.lowercased())_stage_\(stageName)"
    //}
    
    // MARK: - Notifications
    static let notificationIdentifierPrefix = "reminder_"
    
    static let predefinedInteractionTypes: [InteractionType] = [
           InteractionType(name: "Nachricht", sfSymbol: "bubble.right", isCustom: false),
           InteractionType(name: "Anruf", sfSymbol: "phone", isCustom: false),
           InteractionType(name: "Video-Anruf", sfSymbol: "video", isCustom: false),
           InteractionType(name: "Treffen", sfSymbol: "person.2", isCustom: false),
           InteractionType(name: "Sonstiges", sfSymbol: "ellipsis", isCustom: false),
       ]
}
