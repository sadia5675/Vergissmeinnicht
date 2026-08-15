//
//  RelationshipService.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 21.05.26.
//

import Foundation

/// Verwaltet Beziehungen inklusive zugehöriger Benachrichtigungen
@MainActor
class RelationshipService {
    
    static let shared = RelationshipService()
    private let repository = RelationshipRepository()
    private let notificationService = NotificationService.shared
    
    // MARK: - LOAD
    
    /// Lädt alle Beziehungen inkl. berechnetem lastMomentDate
    ///
    /// Dieser Wert wird nicht in CoreData gespeichert, sondern bei jedem Laden live aus den vorhandenen Momenten berechnet —> siehe Relationship
    func loadRelationships() -> [Relationship] {
        repository.loadRelationships().map { relationship in
            var updated = relationship
            updated.lastMomentDate = MomentService.shared.latestMomentDate(for: relationship.id)
            return updated
        }
    }
    
    // MARK: - CREATE
    
    /// Legt eine neue Beziehung an und plant ihre Benachrichtigungen (Pflegeintervall, Geburtstag benutzerdefinierte Erinnerungen)
    func createRelationship(_ relationship: Relationship) {

        repository.saveRelationship(relationship)

        notificationService.requestNotificationPermission()
        notificationService.scheduleIntervalReminder(for: relationship)
        notificationService.scheduleBirthdayReminder(for: relationship)

        for reminder in relationship.customReminders {
            notificationService.scheduleCustomReminder(reminder, for: relationship)
        }
    }
    
    // MARK: - UPDATE
    
    /// Speichert Änderungen und aktualisiert alle Benachrichtigungen
    func updateRelationship(_ relationship: Relationship) {
        repository.saveRelationship(relationship)
        notificationService.refreshIntervalReminder(for: relationship)
        notificationService.refreshBirthdayReminder(for: relationship)
        
        for reminder in relationship.customReminders {
            notificationService.refreshCustomReminder(
                reminder,
                for: relationship
            )
        }
    }
        
    // MARK: - RESTING
    
    /// Versetzt eine Beziehung in den Ruhezustand oder holt sie zurück
    func toggleResting(_ relationship: Relationship) {
        var updated = relationship
        updated.isResting.toggle()

        if updated.isResting {
            // Beim Eintritt in den Ruhezustand: aktuellen Tage-Wert einfrieren
            updated.pausedDaysSince = relationship.getDaysSinceLastContact()
            
        } else if let pausedDays = updated.pausedDaysSince {
            // Beim Verlassen: eingefrorenen Wert zurückrechnen
            updated.lastInteractionDate = Calendar.current.date(
                byAdding: .day,
                value: -pausedDays,
                to: Date()
            )!
            updated.pausedDaysSince = nil
        }
        
        updateRelationship(updated)
        // zusätzliche absicherung da beim update schon guard !relationship.isResting abgefragt wird
        if updated.isResting {
            notificationService.cancelAllNotifications(for: updated)
        }
    }

    
    // MARK: - CUSTOM REMINDERS

    /// Fügt einer Beziehung eine neue benutzerdefinierte Erinnerung hinzu
    func addReminder(_ reminder: CustomReminder, to relationship: Relationship) {
        var updated = relationship
        updated.customReminders.append(reminder)
        updateRelationship(updated)
    }

    /// Aktualisiert eine bestehende benutzerdefinierte Erinnerung
    func updateReminder(_ reminder: CustomReminder, in relationship: Relationship) {
        var updated = relationship
        
        if let index = updated.customReminders.firstIndex( where: { $0.id == reminder.id }) {
            updated.customReminders[index] = reminder
            updateRelationship(updated)
        }
    }

    /// Entfernt eine benutzerdefinierte Erinnerung und storniert ihre geplante Benachrichtigung
    func deleteReminder(_ reminder: CustomReminder,from relationship: Relationship) {
        var updated = relationship
        updated.customReminders.removeAll {$0.id == reminder.id}
        notificationService.deleteCustomReminder(reminder)
        updateRelationship(updated)
    }
    
}
