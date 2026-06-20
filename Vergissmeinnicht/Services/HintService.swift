//
//  HintService.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 21.05.26.
//

import Foundation

@MainActor
class HintService {
    static let shared = HintService()
        

        // MARK: - Single Methode: Generiert einen Hint
        
    private func generateSingleHint(
        for relationship: Relationship
    ) -> Hint? {

        let status = relationship.status
        var displayText: String
        let prefilledMessage: String?
        var selectedMoment: Moment?

        switch relationship.status {
            
        // emotionaler Erinnerungs-Hinweis
        case .missesYou:
            
            // Jahrestag eines Moments -> gleicher Tag und gleicher Monat
            let anniversaryMoments = getAnniversaryMoments(for: relationship)
            
            selectedMoment = anniversaryMoments.first ?? relationship.moments.randomElement()
            
            // falls kein Moment
            guard let moment = selectedMoment else {
                return nil
            }

            let momentData =
                getMomentText(
                    for: moment,
                    relationship: relationship
                )
            
            let template = HintTexts.missingYou.randomElement()!

            displayText = template
                .replacingOccurrences(
                    of: "@MOMENT",
                    with: momentData.text
                )
                .replacingOccurrences(
                    of: "@DAYS",
                    with: "\(momentData.daysSince)"
                )

            displayText =
                HintTexts.replace(
                    text: displayText,
                    with: relationship.name
                )

            prefilledMessage = momentData.prefilledHint
            
        // sanfte Erinnerung
        case .needsCare:
            selectedMoment = nil
            
            let reminder = HintTexts.gentleReminder.randomElement()!
            
            displayText =
                HintTexts.replace(
                    text: reminder.display,
                    with: relationship.name
                )
            
            prefilledMessage =
                HintTexts.replace(
                    text: reminder.prefilled,
                    with: relationship.name
                )
            
        // motivierender Hinweis
        case .blooming:

            selectedMoment = nil

            displayText =
                HintTexts.replace(
                    text: HintTexts.motivational.randomElement()!,
                    with: relationship.name
                )

            prefilledMessage = nil
        }

        return Hint(
            relationshipStatus: relationship.status,
            displayContent: displayText,
            prefilledMessage: prefilledMessage,
            sourceMoment: selectedMoment,
            phoneNumber: relationship.phoneNumber
        )
    }
        
        // MARK: - PUBLIC
        // Eine sanfte und emotionale hints für den Garten
    func generateHintsForGarden(
        for relationships: [Relationship]
    ) -> [Hint] {

        let allHints = relationships.compactMap { rel -> Hint? in

            guard rel.status != .blooming
            else {
                return nil
            }

            return generateSingleHint(for: rel)
        }

        guard let randomHint = allHints.randomElement()
        else {
            return []
        }

        return [randomHint]
    }
    // Genau der Hint erzeugt für die aktuelle geöffnete Beziehung
    func generateHintsForDetail(for relationship: Relationship) -> [Hint] {
        generateSingleHint(for: relationship).map { [$0] } ?? []
    }

    
    // MARK: - HELPER: Jahrestag eines Moments
    
    private func getAnniversaryMoments(for relationship: Relationship) -> [Moment] {
        guard !relationship.moments.isEmpty else { return [] }
        
        let today = Calendar.current
        let todayMonth = today.component(.month, from: Date())
        let todayDay = today.component(.day, from: Date())
        
        let anniversaryMoments = relationship.moments.filter { moment in
            let momentMonth = today.component(.month, from: moment.date)
            let momentDay = today.component(.day, from: moment.date)
            return momentMonth == todayMonth && momentDay == todayDay
        }
        
        return anniversaryMoments.sorted { $0.date > $1.date }
    }
    
    private func getMomentText(for moment: Moment, relationship: Relationship) -> (text: String, prefilledHint: String, daysSince: Int) {
        let calendar = Calendar.current
        let daysSince = calendar.dateComponents([.day], from: moment.date, to: Date()).day ?? 0
        let yearsSince = daysSince / 365
        
        var momentText = ""
        if let notes = moment.notes, !notes.isEmpty {
            momentText = "\"\(notes)\""
        } else {
            momentText = moment.type.name
        }
        
        let timeText: String
        if yearsSince > 0 {
            timeText = "vor \(yearsSince) Jahr\(yearsSince > 1 ? "en" : "")"
        } else {
            timeText = "heute vor \(daysSince) Tag\(daysSince > 1 ? "en" : "")"
        }
        
        let prefilledMessage = "Hey \(relationship.name), ich dachte gerade an unseren \(moment.type.name) \(timeText)... "
        
        return (text: momentText, prefilledHint: prefilledMessage, daysSince: daysSince)
    }
    
    
}
