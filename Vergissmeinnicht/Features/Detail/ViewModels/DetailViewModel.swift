//
//  DetailViewModel.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 22.05.26.
//

import UIKit
import Combine
import Foundation

/// ViewModel für die Detailansicht einer Beziehung
@MainActor
class DetailViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var relationship: Relationship
    @Published var moments: [Moment] = []

    /// Alle Beziehungen
    @Published var allRelationships: [Relationship] = []

    // MARK: - Dependencies

    private let relationshipService = RelationshipService.shared
    private let momentService = MomentService.shared
    private let imageService = ImageService.shared

    // MARK: - Plant Customization Catalog

    var availablePlants: [ImageCatalogEntry] {
        imageService.loadPlants()
    }
    var availablePots: [ImageCatalogEntry] {
        imageService.loadPots()
    }
    var availableBackgrounds: [ImageCatalogEntry] {
        imageService.loadBackgrounds()
    }

    // MARK: - Initialization

    init(relationship: Relationship) {
        self.relationship = relationship
        allRelationships = relationshipService.loadRelationships()
        loadMoments()
    }

    // MARK: - Loading

    /// Sucht anhand der gespeicherten Beziehungs-IDs eines Moments die zugehörigen Relationship-Objekte 
    func participants(for moment: Moment) -> [Relationship] {
        allRelationships.filter {
            moment.relationshipIds.contains($0.id)
        }
    }

    /// Lädt die Beziehung sowie alle Beziehungen neu, damit die Ansicht den aktuellen Stand nach einer Änderung anzeigt
    func loadRelationship() {
        let updated = relationshipService.loadRelationships()
            .first { $0.id == relationship.id }

        if let updated {
            self.relationship = updated
            allRelationships = relationshipService.loadRelationships()
        }
    }

    /// Lädt alle Momente dieser Beziehung, neueste zuerst
    func loadMoments() {
        moments = momentService.loadMoments(for: relationship.id)
            .sorted { $0.date > $1.date }
        relationship.moments = moments
    }

    /// Lädt das zu einem Moment gehörende Foto anhand des gespeicherten Pfads
    func photoFor(_ moment: Moment) -> UIImage? {
        guard let path = moment.photoPath else {
            return nil
        }
        return momentService.loadPhoto(path)
    }

    // MARK: - Editing

    /// Übernimmt die im Bearbeitungsmodus geänderten Werte und speichert die Beziehung
    func saveChanges(
        pot: String?,
        background: String?,
        name: String,
        phoneNumber: String,
        interval: Int,
        birthDate: Date?
    ) {

        var updated = relationship
        updated.plant.pot = pot
        updated.plant.background = background
        updated.name = name
        updated.phoneNumber = phoneNumber
        updated.careRhythm.interval = interval
        updated.birthDate = birthDate

        // Nächste Erinnerung anhand des neuen Pflegerhythmus neu berechnen, ausgehend vom letzten bekannten Kontakt
        updated.careRhythm.nextReminderDate = Calendar.current.date(
            byAdding: .day,
            value: interval,
            to: updated.lastInteractionDate
        ) ?? updated.lastInteractionDate

        relationshipService.updateRelationship(updated)
        self.relationship = updated
        loadRelationship()
    }
    
    /// Versetzt die Beziehung in den Ruhezustand oder holt sie daraus zurück
    func toggleResting() {
        relationshipService.toggleResting(relationship)
        loadRelationship()
    }

    // MARK: - Reminders

    /// Aktiviert oder deaktiviert eine bestehende Erinnerung
    func updateReminder(_ reminder: CustomReminder, isActive: Bool) {
        var updatedReminder = reminder
        updatedReminder.isActive = isActive

        relationshipService.updateReminder(
            updatedReminder,
            in: relationship
        )
        loadRelationship()
    }

    func deleteReminder(_ reminder: CustomReminder) {
        relationshipService.deleteReminder(
            reminder,
            from: relationship
        )
        loadRelationship()
    }

    func addReminder(_ reminder: CustomReminder) {
        relationshipService.addReminder(
            reminder,
            to: relationship
        )
        loadRelationship()
    }
}
