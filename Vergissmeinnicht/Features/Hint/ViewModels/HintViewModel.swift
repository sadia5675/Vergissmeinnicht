//
//  HintViewModel.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 23.05.26.
//

import Combine
import Foundation

/// ViewModel für die Anzeige situationsabhängiger Hinweise in der Gartenübersicht und der Detailansicht
@MainActor
class HintViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var hints: [Hint] = []
    @Published var detailHint: Hint?

    // MARK: - Dependencies

    private let hintService = HintService.shared
    private let dismissalStore = HintDismissalStore.shared

    // MARK: - Loading

    /// Lädt Hinweise für die Gartenübersicht
    /// Wurde der Hinweis heute bereits weggewischt, wird keiner angezeigt
    func loadHints(for relationships: [Relationship]) {
        let eligibleRelationships = relationships.filter {
            !dismissalStore.isDismissedToday($0.id)
        }
        hints = hintService.generateHintsForGarden(for: eligibleRelationships)
    }

    /// Lädt den Hinweis für eine einzelne Beziehung in der Detailansicht
    /// Wurde der Hinweis heute bereits weggewischt, wird keiner angezeigt
    func loadHint(for relationship: Relationship) {
        if dismissalStore.isDismissedToday(relationship.id) {
            detailHint = nil
            return
        }
        detailHint = hintService
            .generateHintsForDetail(for: relationship) // gibt Array zurück
            .first
    }

    // MARK: - Dismiss Actions

    /// Entfernt einen Hinweis aus der Gartenübersicht und merkt das Wegwischen dauerhaft für den Rest des Tages
    func dismissHint(_ id: UUID) {
        if let hint = hints.first(where: { $0.id == id }) {
            dismissalStore.dismiss(hint.relationship.id)
        }
        hints.removeAll { $0.id == id }

        if detailHint?.id == id {
            detailHint = nil
        }
    }

    /// Entfernt den Hinweis in der Detailansicht und merkt das Wegwischen dauerhaft für den Rest des Tages
    func dismissDetailHint(for relationship: Relationship) {
        detailHint = nil
        dismissalStore.dismiss(relationship.id)
    }
}
