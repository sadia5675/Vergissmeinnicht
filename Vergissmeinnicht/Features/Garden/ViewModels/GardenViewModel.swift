//
//  GardenViewModel.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 22.05.26.
//

import Combine
import Foundation

@MainActor
class GardenViewModel: ObservableObject {
    @Published var relationships: [Relationship] = []
    @Published var wellCaredRels: [Relationship] = []
    @Published var needsAttentionRels: [Relationship] = []
    @Published var currentHint: Hint?
    @Published var isLoading = false
    
    private let relationshipService = RelationshipService.shared
    
    func loadRelationships() {
        isLoading = true
        relationships = relationshipService.loadRelationships()
        
        // Moments für jede Relationship laden
        let momentService = MomentService.shared
        for i in 0..<relationships.count {
            relationships[i].moments = momentService.loadMoments(for: relationships[i].id)
            print(
                "\(relationships[i].name): \(relationships[i].moments.count) Moments"
            )
        }
        
        print("Geladen: \(relationships.count) Beziehungen")
        filterRelationships()
        isLoading = false
    }
    
    private func filterRelationships() {
        wellCaredRels = relationships.filter { !$0.isOverdue() }
        needsAttentionRels = relationships.filter { $0.isOverdue() }
    }
    
    func deleteRelationship(_ id: UUID) {
        relationships.removeAll { $0.id == id }
        filterRelationships()
    }
}
