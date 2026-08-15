//
//  MomentRepository.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 27.05.26.
//

import CoreData
import Foundation

/// Speichert und lädt Momente sowie Interaktionstypen aus CoreData
@MainActor
class MomentRepository {

    private let container = PersistenceController.shared.container

    /// Speichert einen neuen Moment mit allen beteiligten Personen
    func saveMoment(_ moment: Moment) {

        let context = container.viewContext
        let entity = MomentEntity(context: context)

        entity.id = moment.id
        entity.date = moment.date
        entity.notes = moment.notes
        entity.photoPath = moment.photoPath

        if let interactionType = fetchInteractionType(
            id: moment.interactionType.id,
            context: context
        ) {
            entity.interactionType = interactionType
        }

        for relationshipId in moment.relationshipIds {

            if let relationship = fetchRelationship(
                id: relationshipId,
                context: context
            ) {
                entity.addToParticipants(relationship)
            }
        }

        save(context)
    }

    /// Lädt alle Momente einer bestimmten Beziehung
    func loadMoments(for relationshipId: UUID) -> [Moment] {
       
        let context = container.viewContext
        let request = NSFetchRequest<MomentEntity>(
            entityName: "MomentEntity"
        )
        request.predicate = NSPredicate(
            format: "ANY participants.id == %@",
            relationshipId as CVarArg
        )

        do {
            let entities = try context.fetch(request)
            
            return entities.map { entity in

                let interactionType: InteractionType

                if let entityType = entity.interactionType {
                    interactionType = InteractionType(
                        id: entityType.id ?? UUID(),
                        name: entityType.name ?? "",
                        sfSymbol: entityType.sfSymbol ?? "star.fill"
                    )

                } else {
                    interactionType = InteractionType(
                        name: "Moment",
                        sfSymbol: "star.fill"
                    )
                }

                let participantIds = (
                    entity.participants as? Set<RelationshipEntity> ?? []
                )
                .compactMap { $0.id }

                return Moment(
                    id: entity.id ?? UUID(),
                    relationshipIds: participantIds,
                    date: entity.date ?? Date(),
                    interactionType: interactionType,
                    notes: entity.notes,
                    photoPath: entity.photoPath
                )
            }

        } catch {
            print(error)
            return []
        }
    }

    /// Gibt das Datum des letzten Moments einer Beziehung zurück, oder nil, wenn es noch keinen gibt
    func latestMomentDate(for relationshipId: UUID) -> Date? {

        let context = container.viewContext
        let request = NSFetchRequest<MomentEntity>(
            entityName: "MomentEntity"
        )
        request.predicate = NSPredicate(
            format: "ANY participants.id == %@",
            relationshipId as CVarArg
        )
        request.sortDescriptors = [
            NSSortDescriptor(key: "date", ascending: false)
        ]
        request.fetchLimit = 1
        do {
            return try context.fetch(request).first?.date

        } catch {
            print(error)
            return nil
        }
    }

    /// Sucht die zu einer ID gehörende, bereits gespeicherte Beziehung
    /// 
    /// Wird gebraucht, um einen Moment mit seinen Teilnehmern zu verknüpfen
    private func fetchRelationship( id: UUID, context: NSManagedObjectContext) -> RelationshipEntity? {

        let request = NSFetchRequest<RelationshipEntity>(
            entityName: "RelationshipEntity"
        )
        request.predicate = NSPredicate(
            format: "id == %@",
            id as CVarArg
        )
        
        return try? context.fetch(request).first
    }

    /// Sucht den zu einer ID gehörenden, bereits gespeicherten Interaktionstyp
    /// 
    /// Wird gebraucht, um einen Moment mit seiner Interaktionsart zu verknüpfen
    private func fetchInteractionType(
        id: UUID,
        context: NSManagedObjectContext
    ) -> InteractionTypeEntity? {

        let request = NSFetchRequest<InteractionTypeEntity>(
            entityName: "InteractionTypeEntity"
        )
        request.predicate = NSPredicate(
            format: "id == %@",
            id as CVarArg
        )

        return try? context.fetch(request).first
    }

    // MARK: - INTERACTION TYPES

    /// Speichert einen neuen Interaktionstyp
    func saveInteractionType(_ interactionType: InteractionType) {

        let context = container.viewContext

        let entity = InteractionTypeEntity(context: context)

        entity.id = interactionType.id
        entity.name = interactionType.name
        entity.sfSymbol = interactionType.sfSymbol

        save(context)
    }

    /// Lädt alle bekannten Interaktionstypen
    func loadInteractionTypes() -> [InteractionType] {

        let context = container.viewContext
        let request = NSFetchRequest<InteractionTypeEntity>(
            entityName: "InteractionTypeEntity"
        )

        do {
            let entities = try context.fetch(request)

            return entities.map {
                InteractionType(
                    id: $0.id ?? UUID(),
                    name: $0.name ?? "",
                    sfSymbol: $0.sfSymbol ?? "star.fill"
                )
            }

        } catch {
            return []
        }
    }

    private func save(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}
