//
//  HintService.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 21.05.26.
//

import Foundation

/// Erzeugt Hinweise zu Beziehungen, passend zu ihrem aktuellen Status
@MainActor
class HintService {

    static let shared = HintService()
    private let textService = TextService.shared

    // MARK: - Generierung

    /// Erzeugt einen Hint für eine Beziehung
    ///
    /// Kein Hint bei Ruhezustand
    private func generateSingleHint(for relationship: Relationship) -> Hint? {

        guard !relationship.isResting else {
            return nil
        }
        
        var displayText: String
        let prefilledMessage: String?
        var selectedMoment: Moment?

        switch relationship.status {

        case .missesYou:

            // Bevorzugt ein Moment vom heutigen Jahrestag, sonst zufällig
            let anniversaryMoments = getAnniversaryMoments(for: relationship)
            selectedMoment = anniversaryMoments.first ?? relationship.moments.randomElement()

            if let moment = selectedMoment {

                let momentData = getMomentText(
                    for: moment,
                    relationship: relationship
                )
                let template = textService.texts.hints.missingYou.randomElement()!

                displayText = template
                    .replacingOccurrences(of: "@MOMENT", with: momentData.text)
                    .replacingOccurrences(
                        of: "@DAYS",
                        with: "\(momentData.daysSince)"
                    )
                    .replacingOccurrences(of: "@NAME", with: relationship.name)

                prefilledMessage = momentData.prefilledHint

            } else {
                
                // Kein Moment vorhanden
                // trotzdem ein Hinweis, statt gar keiner
                let reminder = textService.texts.hints.gentleReminder.randomElement()!

                displayText = reminder.display
                    .replacingOccurrences(of: "@NAME", with: relationship.name)

                prefilledMessage = reminder.prefilled
                    .replacingOccurrences(of: "@NAME", with: relationship.name)
            }

        case .needsCare:

            selectedMoment = nil
            let reminder = textService.texts.hints.gentleReminder.randomElement()!
            displayText = reminder.display
                .replacingOccurrences(of: "@NAME", with: relationship.name)
            prefilledMessage = reminder.prefilled
                .replacingOccurrences(of: "@NAME", with: relationship.name)

        case .blooming:

            selectedMoment = nil
            displayText = textService.texts.hints.motivational.randomElement()!
                .replacingOccurrences(of: "@NAME", with: relationship.name)
            prefilledMessage = nil
        }

        return Hint(
            relationship: relationship,
            relationshipStatus: relationship.status,
            displayContent: displayText,
            prefilledMessage: prefilledMessage,
            sourceMoment: selectedMoment
        )
    }

    // MARK: - PUBLIC

    /// Ein zufälliger Hint für den Garten
    ///
    /// Blühende Beziehungen werden bewusst ausgeschlossen
    func generateHintsForGarden(for relationships: [Relationship]) -> [Hint] {

        let allHints = relationships.compactMap { rel -> Hint? in
            guard rel.status != .blooming else {
                return nil
            }
            return generateSingleHint(for: rel)
        }
        guard let randomHint = allHints.randomElement() else {
            return []
        }
        return [randomHint]
    }

    /// Ein Hint für die geöffnete Beziehung, unabhängig vom Status (Detailansicht)
    func generateHintsForDetail(for relationship: Relationship) -> [Hint] {
        if let hint = generateSingleHint(for: relationship) {
            return [hint]
        } else {
            return []
        }
    }

    // MARK: - HELPER: Jahrestag eines Moments

    /// Filtert alle Momente einer Beziehung, die exakt heute vor einem oder mehreren Jahren stattfanden (gleicher Tag, gleicher Monat)
    private func getAnniversaryMoments(for relationship: Relationship) -> [Moment] {

        guard !relationship.moments.isEmpty else {
            return []
        }
        let calendar = Calendar.current
        let todayMonth = calendar.component(.month, from: Date())
        let todayDay = calendar.component(.day, from: Date())

        let anniversaryMoments = relationship.moments.filter { moment in
            let momentMonth = calendar.component(.month, from: moment.date)
            let momentDay = calendar.component(.day, from: moment.date)
            return momentMonth == todayMonth && momentDay == todayDay
        }
        return anniversaryMoments.sorted { $0.date > $1.date }
    }

    /// Anzeigetext, vorausgefüllte Nachricht und Tage seit einem Moment
    private func getMomentText(
        for moment: Moment,
        relationship: Relationship
    ) -> (text: String, prefilledHint: String, daysSince: Int) {

        let calendar = Calendar.current
        let daysSince = calendar.dateComponents(
            [.day],
            from: moment.date,
            to: Date()
        ).day ?? 0

        let yearsSince = daysSince / 365
        let momentText: String
        
        if let notes = moment.notes, !notes.isEmpty {
            momentText = "\"\(notes)\""
        } else {
            momentText = moment.interactionType.name
        }
        
        let prefilledMessage: String

        if yearsSince > 0 {
            let timeText = "vor \(yearsSince) Jahr\(yearsSince > 1 ? "en" : "")"
            prefilledMessage =
                "Hey \(relationship.name), ich dachte gerade an unseren " +
                "\(moment.interactionType.name) \(timeText). Lass uns das bald wiederholen! "
        } else {
            prefilledMessage =
                "Hey \(relationship.name), ich dachte gerade an unseren " +
                "\(moment.interactionType.name). Lass uns das bald wiederholen!"
        }

        return (
            text: momentText,
            prefilledHint: prefilledMessage,
            daysSince: daysSince
        )
    }
}
