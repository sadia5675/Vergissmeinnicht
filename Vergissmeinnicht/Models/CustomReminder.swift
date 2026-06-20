//
//  CustomReminder.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 21.05.26.
//

import Foundation

struct CustomReminder: Identifiable, Equatable {
    let id: UUID
    var date: Date
    var label: String
    var isActive: Bool
    
    init(id: UUID = UUID(), date: Date, label: String, isActive: Bool = true) {
        self.id = id
        self.date = date
        self.label = label
        self.isActive = isActive
    }
    
    func isUpcoming() -> Bool {
        return date > Date() && isActive
    }
}
