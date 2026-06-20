//
//  MomentService.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 27.05.26.
//
import UIKit
import Foundation

@MainActor
class MomentService {

    static let shared = MomentService()

    private let repository =
        MomentRepository()

    private let relationshipService = RelationshipService.shared

    // MARK: - SAVE MOMENTS

    func saveMoment(
        _ moment: Moment,
        for relationship: Relationship
    ) {
        repository.saveMoment(moment)

        var updatedRelationship = relationship
        updatedRelationship.lastInteractionDate = moment.date
        updatedRelationship.careRhythm.nextReminderDate =
            Calendar.current.date(byAdding: .day, value: updatedRelationship.careRhythm.interval, to: moment.date)

        relationshipService.updateRelationship(updatedRelationship)
        // ← Das regelt bereits die Notifications!
    }
    
    
    func saveMomentForAll(
        _ moment: Moment
    ) {

        // EIN gemeinsamer Moment
        repository.saveMoment(moment)

        // Alle Teilnehmer aktualisieren
        for relationshipId in moment.relationshipIds {

            let all =
                relationshipService.loadRelationships()

            if var rel =
                all.first(where: {
                    $0.id == relationshipId
                })
            {

                let currentStage =
                    PlantStageService.shared
                        .calculateStage(for: rel)

                rel.plant.growthStage =
                    min(3, currentStage + 1)

                rel.lastInteractionDate =
                    moment.date

                rel.careRhythm.nextReminderDate =
                    Calendar.current.date(
                        byAdding: .day,
                        value: rel.careRhythm.interval,
                        to: moment.date
                    )

                relationshipService
                    .updateRelationship(rel)
            }
        }
    }

    // MARK: - INTERACTION TYPES

    func saveInteractionType(
        _ type: InteractionType
    ) {

        repository.saveInteractionType(type)
    }

    func loadInteractionTypes()
        -> [InteractionType] {

        repository.loadInteractionTypes()
    }
    
    func seedInteractionTypesIfNeeded() {

        let existing =
            loadInteractionTypes()

        if existing.isEmpty {

            for type in
                AppConstants.predefinedInteractionTypes {

                saveInteractionType(type)
            }

            print("InteractionTypes angelegt")
        }
    }

    // MARK: - LOAD MOMENTS

    func loadMoments(
        for relationshipId: UUID
    ) -> [Moment] {

        repository.loadMoments(
            for: relationshipId
        )
    }
    
    // MARK: - PHOTOS

    func savePhoto(_ image: UIImage) -> String? {
        let folder = getPhotoFolder()
        let filename = UUID().uuidString + ".jpg"
        let url = folder.appendingPathComponent(filename)
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        try? data.write(to: url)
        return filename
    }

    func loadPhoto(_ filename: String) -> UIImage? {
        let url = getPhotoFolder().appendingPathComponent(filename)
        return UIImage(contentsOfFile: url.path)
    }

    func deletePhoto(_ filename: String) {
        let url = getPhotoFolder().appendingPathComponent(filename)
        try? FileManager.default.removeItem(at: url)
    }

    private func getPhotoFolder() -> URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dir = docs.appendingPathComponent("MomentPhotos")
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }
}
