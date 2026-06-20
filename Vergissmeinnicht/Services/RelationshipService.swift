//
//  RelationshipService.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 21.05.26.
//

import Foundation

@MainActor
class RelationshipService {
    
    static let shared =
    RelationshipService()
    
    private let repository =
    RelationshipRepository()
    
    private let notificationService =
    NotificationService.shared
    
    // MARK: - LOAD
    
    func loadRelationships()
    -> [Relationship] {
        
        repository.loadRelationships()
    }
    
    // MARK: - CREATE
    
    func createRelationship(
        _ relationship: Relationship
    ) {
        
        repository.saveRelationship(
            relationship
        )
        
        notificationService
            .requestNotificationPermission()
        
        notificationService
            .scheduleIntervalReminder(
                for: relationship
            )
        
        if relationship.birthDate != nil {
            
            notificationService
                .scheduleBirthdayReminder(
                    for: relationship
                )
        }
        
        for reminder in
                relationship.customReminders {
            
            notificationService
                .scheduleCustomReminder(
                    reminder,
                    for: relationship
                )
        }
    }
    
// MARK: - UPDATE
    
    func updateRelationship(
        _ relationship: Relationship
    ) {
        
        repository.saveRelationship(
            relationship
        )

        notificationService
            .refreshIntervalReminder(
                for: relationship
            )
        
        notificationService
            .refreshBirthdayReminder(
                for: relationship
            )
        
        for reminder in
                relationship.customReminders {
            
            notificationService
                .refreshCustomReminder(
                    reminder,
                    for: relationship
                )
        }
    }
        
        // MARK: - DELETE
        
        /*  func deleteRelationship(
         _ relationship: Relationship
         ) {
         
         repository.deleteRelationship(
         relationship.id
         )
         
         notificationService
         .cancelReminders(
         for: relationship.id
         )
         }*/
    
    // MARK: - CUSTOM REMINDERS

    func addReminder(
        _ reminder: CustomReminder,
        to relationship: Relationship
    ) {

        var updated = relationship

        updated.customReminders.append(
            reminder
        )

        updateRelationship(
            updated
        )
    }

    func updateReminder(
        _ reminder: CustomReminder,
        in relationship: Relationship
    ) {

        var updated = relationship

        if let index =
            updated.customReminders.firstIndex(
                where: { $0.id == reminder.id }
            ) {

            updated.customReminders[index] =
                reminder

            updateRelationship(
                updated
            )
        }
    }

    func deleteReminder(
        _ reminder: CustomReminder,
        from relationship: Relationship
    ) {

        var updated = relationship

        updated.customReminders.removeAll {
            $0.id == reminder.id
        }

        notificationService
            .deleteCustomReminder(
                reminder
            )

        updateRelationship(
            updated
        )
    }
    
}
