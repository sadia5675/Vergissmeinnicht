//
//  MomentViewModel.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 23.05.26.
//

import UIKit
import Combine
import Foundation

/// ViewModel für das Festhalten eines Moments mit einer oder mehreren Personen und die Berechnung der ausgelösten Pflanzenwachstums-Änderung
@MainActor
class MomentViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var selectedInteractionType: InteractionType
    @Published var notes: String = ""
    @Published var selectedImage: UIImage? = nil
    @Published var isLoading = false
    @Published var selectedDate: Date = Date()

    /// Beteiligte Personen als Set, da jede Person nur einmal ausgewählt sein kann
    @Published var selectedParticipants: Set<UUID>

    @Published var allRelationships: [Relationship] = []
    @Published var interactionTypes: [InteractionType] = []

    // MARK: - Dependencies

    private let relationshipService = RelationshipService.shared
    private let momentService = MomentService.shared
    private let plantStageService = PlantStageService.shared
    private let imageService = ImageService.shared

    /// Falls von DetailView eine feste Person mitgegeben wurde sonst nil
    let preselectedRelationship: Relationship?

    // MARK: - Notizvorschläge

    /// Vorgefertigte Textbausteine, passend zur gewählten Interaktionsart
    var noteTemplates: [String] {
        switch selectedInteractionType.name {

        case "Nachricht":
            return [
                "Schöne Unterhlatung",
                "Hat mich gefreut",
                "Wieder gemeldet"
            ]
        case "Treffen":
            return [
                "War schön!",
                "Zu lang nicht gesehen",
                "Haben viel gelacht"
            ]
        case "Anruf":
            return [
                "Tolles Gespräch",
                "Lange telefoniert",
                "Hat gut getan"
            ]
        case "Video-Anruf":
            return [
                "Schön, dein Gesicht zu sehen",
                "Tolles Gespräch",
                "Fühlte sich vertraut an"
            ]
        default:
            return [
                "War schön!",
                "Hat mich gefreut",
                "Wieder gemeldet"
            ]
        }
    }

    // MARK: - Initialisierung

    /// Übernimmt eine optional vorausgewählte Person und setzt sie als ersten Teilnehmer
    ///
    /// Lädt anschließend die verfügbaren Personen und Interaktionstypen
    init(relationship: Relationship? = nil) {
        self.preselectedRelationship = relationship
        if let relationship {
            self.selectedParticipants = [relationship.id]
        } else {
            self.selectedParticipants = []
        }

        // Platzhalter, bis die echten Interaktionstypen geladen sind
        self.selectedInteractionType = InteractionType(
            name: "Nachricht",
            sfSymbol: "bubble.right"
        )
        loadParticipants()
        loadInteractionTypes()
        if let firstType = interactionTypes.first {
            self.selectedInteractionType = firstType
        }
    }

    // MARK: - Loading

    func loadInteractionTypes() {
        interactionTypes = momentService.loadInteractionTypes()
    }

    /// Lädt alle aktiven Beziehungen als mögliche Teilnehmer:innen
    /// 
    /// Ruhende Beziehungen und bereits vorausgewählte Person werden aus der Auswahlliste ausgeschlossen
    private func loadParticipants() {
        let all = relationshipService.loadRelationships().filter {
            !$0.isResting
        }
        if let preselectedRelationship {
            allRelationships = all.filter {
                $0.id != preselectedRelationship.id
            }
        } else {
            allRelationships = all
        }
    }

    // MARK: - Save

    /// Bündelt die alte und neue Wachstumsstufe einer Beziehung, um nach dem Speichern eine Wachstums-Animation anzeigen zu können
    struct GrowthResult {
        let oldStage: Int
        let newStage: Int
        let plantName: String
        let relationshipName: String
    }

    /// Speichert den Moment und ermittelt für jede beteiligte Person, ob sich die Wachstumsstufe dadurch verändert hat
    func saveMoment() -> [GrowthResult]? {
        guard !selectedParticipants.isEmpty else {
            return nil
        }
        isLoading = true
        let photoPath = selectedImage.flatMap {
            momentService.savePhoto($0)
        }
        let allParticipants = Array(selectedParticipants)

        let moment = Moment(
            relationshipIds: allParticipants,
            date: selectedDate,
            interactionType: selectedInteractionType,
            notes: notes.isEmpty ? nil : notes,
            photoPath: photoPath
        )

        // Wachstumsstufe jeder beteiligten Person vor dem Speichern merken, um sie später mit dem neuen Stand vergleichen zu können
        let before = relationshipService.loadRelationships()
        var oldStages: [UUID: Int] = [:]

        for rel in before where allParticipants.contains(rel.id) {
            oldStages[rel.id] = plantStageService.calculateStage(for: rel)
        }
        momentService.saveMomentForAll(moment)

        // Beziehungen erneut laden, um die aktualisierten Wachstumsstufen mit dem zuvor gemerkten Stand zu vergleichen
        let after = relationshipService.loadRelationships()
        var results: [GrowthResult] = []

        for id in allParticipants {
            guard let updated = after.first(where: { $0.id == id }) else {
                continue
            }
            let newStage = plantStageService.calculateStage(for: updated)
            let oldStage = oldStages[id] ?? newStage

            results.append(
                GrowthResult(
                    oldStage: oldStage,
                    newStage: newStage,
                    plantName: updated.plant.type,
                    relationshipName: updated.name
                )
            )
        }
        isLoading = false
        return results
    }

    /// Lädt die Pflanzenbilder zur alten und neuen Wachstumsstufe für die Wachstums-Animation
    func growthImages(
        plantName: String,
        oldStage: Int,
        newStage: Int
    ) -> (UIImage?, UIImage?) {

        (
            imageService.getPlantImage(name: plantName, stage: oldStage),
            imageService.getPlantImage(name: plantName, stage: newStage)
        )
    }
}
