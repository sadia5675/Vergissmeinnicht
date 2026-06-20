//
//  DetailViewModel.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 22.05.26.
//

import UIKit
import Combine
import Foundation

@MainActor
class DetailViewModel: ObservableObject {
    @Published var relationship: Relationship
    @Published var moments: [Moment] = []
    @Published var allRelationships: [Relationship] = []
   // @Published var hint: Hint?
    
    private let relationshipService = RelationshipService.shared
    private let momentService =
        MomentService.shared
    
    // private let hintService = HintService.shared
    
    init(relationship: Relationship) {
        self.relationship = relationship
        allRelationships =
              RelationshipService.shared
                  .loadRelationships()
        loadMoments()
       // loadHint()
    }
    func participants(
        for moment: Moment
    ) -> [Relationship] {

        allRelationships.filter {
            moment.relationshipIds.contains($0.id)
        }
    }
    
    func loadRelationship() {
        let updated = relationshipService.loadRelationships()
            .first { $0.id == relationship.id }
        if let updated = updated {
            self.relationship = updated
            print("Relationship reloaded!")
        }
    }
    
   // func loadHint() {
    //    let hints = hintService.generateHintsForDetail(for: relationship)
    //    hint = hints.first
   // }
    
    
       func loadMoments() {
           moments = momentService.loadMoments(for: relationship.id)
                      .sorted { $0.date > $1.date }
              self.relationship.moments = moments
            //loadHint()
              print("\(moments.count) Moments in Relationship eingefügt")
              }

    func saveChanges(name: String, interval: Int, birthDate: Date?) {
        var updated = relationship
        updated.name = name
        updated.careRhythm.interval = interval
        updated.birthDate = birthDate
        updated.careRhythm.nextReminderDate = Calendar.current.date(
            byAdding: .day, value: interval,
            to: updated.lastInteractionDate ?? Date()
        )
        relationshipService.updateRelationship(updated)
        self.relationship = updated
        loadRelationship()
    }
    
    func photoFor(_ moment: Moment) -> UIImage? {
        guard let path = moment.photoPath else { return nil }
        return momentService.loadPhoto(path)
    }
    
    func updateReminder(
        _ reminder: CustomReminder,
        isActive: Bool
    ) {

        print("Toggle gedrückt: \(isActive)")

        var updatedReminder = reminder
        updatedReminder.isActive = isActive

        relationshipService.updateReminder(
            updatedReminder,
            in: relationship
        )

        loadRelationship()
    }
    
    func deleteReminder(
        _ reminder: CustomReminder
    ) {

        relationshipService.deleteReminder(
            reminder,
            from: relationship
        )

        loadRelationship()
    }
    
    func addReminder(
        _ reminder: CustomReminder
    ) {

        relationshipService.addReminder(
            reminder,
            to: relationship
        )

        loadRelationship()
    }

    
  /*  func recordMoment() {
        let moment = Moment(
            relationshipIds: [relationship.id],
            date: Date(),
            type: InteractionType(
                id: UUID(),
                name: "Nachricht",
                sfSymbol: "bubble.right",
                isCustom: false
            )
        )
        
        relationshipService.saveMoment(moment)
        
        var updated = relationship
        updated.lastInteractionDate = moment.date
        updated.moments.append(moment)
        relationshipService.saveRelationship(updated)
        self.relationship = updated
        loadMoments() 
    }*/
}

