//
//  RelationshipRepository.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 27.05.26.
//

import CoreData
import Foundation

@MainActor
class RelationshipRepository {

    private let container = PersistenceController.shared.container

    func loadRelationships() -> [Relationship] {

        let context = container.viewContext

        let request = NSFetchRequest<RelationshipEntity>(
            entityName: "RelationshipEntity"
        )

        request.sortDescriptors = [
            NSSortDescriptor(
                keyPath: \RelationshipEntity.name,
                ascending: true
            )
        ]

        do {
            let entities = try context.fetch(request)

            return entities.map {
                convertToModel($0)
            }

        } catch {
            print(error)
            return []
        }
    }

    func saveRelationship(_ relationship: Relationship) {

        let context = container.viewContext

        let request = NSFetchRequest<RelationshipEntity>(
            entityName: "RelationshipEntity"
        )

        request.predicate = NSPredicate(
            format: "id == %@",
            relationship.id as CVarArg
        )

        let entity: RelationshipEntity

        do {

            let existing = try context.fetch(request)

            if let found = existing.first {
                entity = found
            } else {
                entity = RelationshipEntity(context: context)
            }

        } catch {
            entity = RelationshipEntity(context: context)
        }

        entity.id = relationship.id
        entity.name = relationship.name
        entity.phoneNumber = relationship.phoneNumber
        entity.birthDate = relationship.birthDate
        entity.createdDate = relationship.createdDate
        entity.lastInteractionDate = relationship.lastInteractionDate

        if let existingPlant = entity.plant {

            // Bestehende Plant updaten
            print(" Existing Plant gefunden, update...")
            existingPlant.id = relationship.plant.id
            existingPlant.type = relationship.plant.type
            print("   Neuer type: \(existingPlant.type ?? "nil")")
            existingPlant.pot = relationship.plant.pot
            existingPlant.background = relationship.plant.background
            existingPlant.momentCount = Int32(relationship.plant.momentCount)
            existingPlant.lastUpdated = relationship.plant.lastUpdated

        } else {

            // Neue Plant erstellen
            print(" Neue Plant erstellen...")
            entity.plant = savePlant(
                relationship.plant,
                context: context
            )
        }

        if let existingRhythm =
            entity.careRhythm {

            existingRhythm.id =
                relationship.careRhythm.id

            existingRhythm.interval =
                Int32(
                    relationship.careRhythm.interval
                )

            existingRhythm.nextReminderDate =
                relationship.careRhythm
                    .nextReminderDate

        } else {

            entity.careRhythm =
                saveCareRhythm(
                    relationship.careRhythm,
                    context: context
                )
        }
        
        // MARK: - CUSTOM REMINDERS

        // Alte Reminder löschen
        if let oldReminders =
            entity.customReminders
                as? Set<CustomReminderEntity> {

            for old in oldReminders {
                context.delete(old)
            }
        }

        // Neue Reminder speichern
        for reminder in relationship.customReminders {

            let reminderEntity =
                CustomReminderEntity(context: context)

            reminderEntity.id = reminder.id
            reminderEntity.date = reminder.date
            reminderEntity.label = reminder.label
            reminderEntity.isActive = reminder.isActive

            entity.addToCustomReminders(
                reminderEntity
            )
        }

        save(context)
    }

    private func savePlant(
        _ plant: Plant,
        context: NSManagedObjectContext
    ) -> PlantEntity {
        
        let entity = PlantEntity(context: context)
        
        entity.id = plant.id
        entity.type = plant.type
        entity.pot = plant.pot
        entity.background = plant.background
        entity.momentCount = Int32(plant.momentCount)
        entity.lastUpdated = plant.lastUpdated
        
        return entity
    }

    private func saveCareRhythm(
        _ careRhythm: CareRhythm,
        context: NSManagedObjectContext
    ) -> CareRhythmEntity {

        let entity = CareRhythmEntity(context: context)

        entity.id = careRhythm.id
        entity.interval = Int32(careRhythm.interval)
        entity.nextReminderDate = careRhythm.nextReminderDate

        return entity
    }

    private func convertToModel(
        _ entity: RelationshipEntity
    ) -> Relationship {
        
        print(" Laden: \(entity.name ?? "?")")
        print("   plant.type: \(entity.plant?.type ?? "nil")")
        print("background: \(entity.plant?.background ?? "nil")")

        let plant = Plant(
            id: entity.plant?.id ?? UUID(),
            type: entity.plant?.type ?? "cosmos",
            pot: entity.plant?.pot,
            background: entity.plant?.background,
            momentCount: Int(entity.plant?.momentCount ?? 0)
        )

        let careRhythm = CareRhythm(
            id: entity.careRhythm?.id ?? UUID(),
            interval: Int(entity.careRhythm?.interval ?? 7),
            nextReminderDate: entity.careRhythm?.nextReminderDate
        )

        var relationship = Relationship(
            id: entity.id ?? UUID(),
            name: entity.name ?? "",
            phoneNumber:
                entity.phoneNumber ?? "",
            birthDate: entity.birthDate,
            plant: plant,
            careRhythm: careRhythm,
            moments: [],
            customReminders: loadCustomReminders(from: entity),
        )

        relationship.lastInteractionDate =
            entity.lastInteractionDate

        return relationship
    }
    
    private func loadCustomReminders(
        from entity: RelationshipEntity
    ) -> [CustomReminder] {

        guard let entities =
            entity.customReminders
                as? Set<CustomReminderEntity>
        else {
            return []
        }

        return entities.map {

            CustomReminder(
                id: $0.id ?? UUID(),
                date: $0.date ?? Date(),
                label: $0.label ?? "",
                  isActive: $0.isActive
            )
        }
        .sorted { $0.date < $1.date }
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
