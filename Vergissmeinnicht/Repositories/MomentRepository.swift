//
//  MomentRepository.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 27.05.26.
//

import CoreData
import Foundation

@MainActor
class MomentRepository {

    private let container =
        PersistenceController.shared.container

    func saveMoment(_ moment: Moment) {

        let context = container.viewContext

        let entity = MomentEntity(context: context)

        entity.id = moment.id
        entity.date = moment.date
        entity.notes = moment.notes
        entity.photoPath = moment.photoPath
        entity.interactionTypeId = moment.type.id
        for relationshipId in moment.relationshipIds {

            if let relationship =
                fetchRelationship(
                    id: relationshipId,
                    context: context
                ) {

                entity.addToParticipants(
                    relationship
                )
            }
        }

        save(context)
    }

    func loadMoments(
        for relationshipId: UUID
    ) -> [Moment] {

        let context = container.viewContext

        let request =
            NSFetchRequest<MomentEntity>(
                entityName: "MomentEntity"
            )

        request.predicate =
            NSPredicate(
                format: "ANY participants.id == %@",
                relationshipId as CVarArg
            )

        do {

            let filtered =
                try context.fetch(request)

            let allTypes =
                loadInteractionTypes()

            return filtered.map { entity in

                let type =
                    allTypes.first {
                        $0.id == entity.interactionTypeId
                    }
                    ??
                    InteractionType(
                        name: "Moment",
                        sfSymbol: "star.fill"
                    )

                let participantIds =
                    (
                        entity.participants
                            as? Set<RelationshipEntity>
                        ?? []
                    )
                    .compactMap {
                        $0.id
                    }

                return Moment(
                    id: entity.id ?? UUID(),
                    relationshipIds: participantIds,
                    date: entity.date ?? Date(),
                    type: type,
                    notes: entity.notes,
                    photoPath: entity.photoPath
                )
            }

        } catch {

            print(error)
            return []
        }
    }
    
    
    private func fetchRelationship(
        id: UUID,
        context: NSManagedObjectContext
    ) -> RelationshipEntity? {

        let request =
            NSFetchRequest<RelationshipEntity>(
                entityName: "RelationshipEntity"
            )

        request.predicate =
            NSPredicate(
                format: "id == %@",
                id as CVarArg
            )

        return try? context.fetch(request).first
    }
    
    // MARK: - INTERACTION TYPES

    func saveInteractionType(
        _ type: InteractionType
    ) {

        let context = container.viewContext

        let entity =
            InteractionTypeEntity(
                context: context
            )

        entity.id = type.id
        entity.name = type.name
        entity.sfSymbol = type.sfSymbol
        entity.isCustom = type.isCustom

        save(context)
    }

    func loadInteractionTypes()
    -> [InteractionType] {

        let context = container.viewContext

        let request =
            NSFetchRequest<InteractionTypeEntity>(
                entityName: "InteractionTypeEntity"
            )

        do {

            let entities =
                try context.fetch(request)

            return entities.map {

                InteractionType(
                    id: $0.id ?? UUID(),
                    name: $0.name ?? "",
                    sfSymbol: $0.sfSymbol ?? "star.fill",
                    isCustom: $0.isCustom
                )
            }

        } catch {

            return []
        }
    }
    private func save(
        _ context: NSManagedObjectContext
    ) {

        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
}
