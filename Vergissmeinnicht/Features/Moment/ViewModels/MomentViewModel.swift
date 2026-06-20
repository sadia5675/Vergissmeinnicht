//
//  MomentViewModel.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 23.05.26.
//
import UIKit
import Combine
import Foundation

@MainActor
class MomentViewModel: ObservableObject {

    @Published var selectedInteractionType:
        InteractionType

    @Published var notes: String = ""
    @Published var selectedImage: UIImage? = nil

    @Published var isLoading = false
    
    @Published var additionalParticipants: Set<UUID> = []
    @Published var allRelationships: [Relationship] = []
    @Published var interactionTypes: [InteractionType] = []
    
    private let relationshipService =
        RelationshipService.shared
    
    var noteTemplates: [String] {

        switch selectedInteractionType.name {

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

        default:
            return [
                "War schön!",
                "Hat mich gefreut",
                "Wieder gemeldet"
            ]
        }
    }

    let relationship: Relationship

    private let momentService =
        MomentService.shared

    // MARK: - ALL INTERACTION TYPES

   // var allInteractionTypes: [InteractionType] {
    //    momentService.loadInteractionTypes()
   // }
    
    func loadInteractionTypes() {
        interactionTypes =
            momentService.loadInteractionTypes()
    }
    
    
    private func loadParticipants() {

        let all =
            relationshipService.loadRelationships()

        allRelationships =
            all.filter {
                $0.id != relationship.id
            }
    }
    
    // MARK: - INIT

    init(relationship: Relationship) {

        self.relationship = relationship

        let defaultType = InteractionType(
            name: "Nachricht",
            sfSymbol: "bubble.right"
        )

        self.selectedInteractionType = defaultType

        loadParticipants()

        loadInteractionTypes()

        if let firstType =
            interactionTypes.first {

            self.selectedInteractionType =
                firstType
        }
    }
    
    func toggleParticipant(_ id: UUID) {
        if additionalParticipants.contains(id) {
            additionalParticipants.remove(id)
        } else {
            additionalParticipants.insert(id)
        }
    }


    // MARK: - SAVE MOMENT

    func saveMoment() -> Bool {
        isLoading = true
        
        // Foto speichern falls vorhanden
        let photoPath = selectedImage.flatMap { momentService.savePhoto($0) }
        
        // Alle Teilnehmer: Haupt-Person + ausgewählte
            var allIds = [relationship.id]
            allIds.append(contentsOf: additionalParticipants)
        
        let moment = Moment(
            relationshipIds: allIds,
            date: Date(),
            type: selectedInteractionType,
            notes: notes.isEmpty ? nil : notes,
            photoPath: photoPath
        )
        
        momentService.saveMomentForAll(moment)
        isLoading = false
        return true
    }
}
