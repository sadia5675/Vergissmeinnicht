//
//  GardenViewModel.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 22.05.26.
//

import Combine
import Foundation

/// ViewModel für die Gartenübersicht, zuständig für das Laden und Filtern aller Beziehungen und die Verwaltung des Gartennamens
@MainActor
class GardenViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var relationships: [Relationship] = []
    @Published var wellCaredRels: [Relationship] = []
    @Published var needsAttentionRels: [Relationship] = []
    @Published var restingRels: [Relationship] = []
    @Published var isLoading = false

    /// Name des Gartens, wird aus UserDefaults geladen und dort auch gespeichert
    @Published var gardenName = UserDefaults.standard.string(forKey: "gardenName") ?? "Mein Garten"

    // MARK: - Dependencies

    private let relationshipService = RelationshipService.shared
    private let momentService = MomentService.shared

    // MARK: - Loading

    /// Lädt alle Beziehungen mit ihren Momenten und sortiert sie anschließend in die drei Kategorien ein
    func loadRelationships() {
        isLoading = true
        relationships = relationshipService.loadRelationships()
        for i in 0..<relationships.count {
            relationships[i].moments = momentService.loadMoments(
                for: relationships[i].id
            )
        }
        filterRelationships()
        isLoading = false
    }

    /// Teilt alle Beziehungen in Ruhezustand, gut gepflegt und braucht Aufmerksamkeit auf
    private func filterRelationships() {
        restingRels = relationships.filter {
            $0.isResting
        }
        wellCaredRels = relationships.filter {
            !$0.isResting && !$0.isOverdue()
        }
        needsAttentionRels = relationships.filter {
            !$0.isResting && $0.isOverdue()
        }
    }

    // MARK: - Garden

    /// Aktualisiert den Gartennamen und speichert ihn dauerhaft
    func updateGardenName(_ name: String) {
        gardenName = name
        UserDefaults.standard.set(
            name,
            forKey: "gardenName"
        )
    }
}
