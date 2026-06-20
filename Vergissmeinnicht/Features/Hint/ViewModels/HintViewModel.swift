//
//  HintViewModel.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 23.05.26.
//

import Combine
import Foundation

@MainActor
class HintViewModel: ObservableObject {
    @Published var hints: [Hint] = []
    @Published var detailHint: Hint?
    @Published var lastHintDismissedDate: Date?
    
    private let hintService = HintService.shared
    
    func loadHints(for relationships: [Relationship]) {
        // Prüfe ob HEUTE schon einen dismissed
        let today = Calendar.current.startOfDay(for: Date())
        let lastDismissedDay = lastHintDismissedDate.map { Calendar.current.startOfDay(for: $0) }
        
        if lastDismissedDay == today {
            print("Heute schon einen Hint dismissed - keine neuen!")
            hints = []
            return
        }
        
        print("Neuer Tag! Lade neue Hints...")
        let allHints = hintService.generateHintsForGarden(for: relationships)
        hints = allHints
    }
    
    func loadHint(
        for relationship: Relationship
    ) {
        detailHint =
            hintService
                .generateHintsForDetail(
                    for: relationship
                )
                .first
    }
    
    func dismissHint(_ id: UUID) {
        hints.removeAll { $0.id == id }
        lastHintDismissedDate = Date()  // Merke HEUTE!
    }
    
}
