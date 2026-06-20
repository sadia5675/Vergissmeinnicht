//
//  CareRhythm.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 21.05.26.
//

import Foundation

struct CareRhythm: Identifiable {
    let id: UUID
    var interval: Int
    var nextReminderDate: Date?
    
    // INIT: Für neue Relationships
       init(id: UUID = UUID(), interval: Int) {
           self.id = id
           self.interval = interval
           self.nextReminderDate = Calendar.current.date(
               byAdding: .day,
               value: interval,
               to: Date()
           )
       }
       
       // INIT: Für laden aus DB
       init(id: UUID, interval: Int, nextReminderDate: Date?) {
           self.id = id
           self.interval = interval
           self.nextReminderDate = nextReminderDate
       }
    
    func daysSince(_ date: Date) -> Int {
        let calendar = Calendar.current
        
        // Setze beide auf Mitternacht Start of Day
        let startOfLast = calendar.startOfDay(for: date)
        let startOfToday = calendar.startOfDay(for: Date())
        
        let components = calendar.dateComponents([.day], from: startOfLast, to: startOfToday)
        return components.day ?? 0
    }
    
    func isOverdue(lastInteraction: Date) -> Bool {
        let daysSince = daysSince(lastInteraction)
        return daysSince >= interval
    }
    
    static var presets: [Int] {
        return AppConstants.careRhythmPresets
    }
}
