//
//  DateFormatter+Relationship.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 09.06.26.
//

import Foundation

struct RelationshipDateFormatter {
    
    static func formatDaysSince(_ days: Int) -> String {
        if days == Int.max {
            return "Frisch gepflanzt"
        } else if days == 0 {
            return "heute"
        } else if days == 1 {
            return "gestern"
        } else {
            return "vor \(days) Tagen"
        }
    }
}
