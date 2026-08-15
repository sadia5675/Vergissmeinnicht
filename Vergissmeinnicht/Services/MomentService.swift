//
//  MomentService.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 27.05.26.
//

import UIKit
import Foundation

/// Verwaltet Momente: Speichern, Laden, die zugehörigen Fotos sowie die verfügbaren Interaktionstypen
@MainActor
class MomentService {

    static let shared = MomentService()
    private let repository = MomentRepository()
    private let relationshipService = RelationshipService.shared

    // MARK: - SAVE MOMENTS

    /// Speichert einen Moment für alle beteiligten Beziehungen gemeinsam
    func saveMomentForAll(_ moment: Moment) { //TODO: ändern, da teurer Aufruf --> alle Beziehung werden geladen

        repository.saveMoment(moment)
        let all = relationshipService.loadRelationships()

        for relationshipId in moment.relationshipIds {

            if var rel = all.first(where: { $0.id == relationshipId }) {
                let currentCount = PlantStageService.shared.currentMomentCount(
                    for: rel
                )
                
                // Jede Pflanze wächst dabei einen Schritt weiter (maximal bis 9 momenten)
                rel.plant.momentCount = min(9, currentCount + 1)

                // Das Datum "letzter Kontakt" wird anhand aller bisher dokumentierten Momente neu bestimmt, damit der tatsächlich neueste Moment gilt, unabhängig davon, in welcher Reihenfolge Momente eingetragen wurden
                let allMoments = repository.loadMoments(for: relationshipId)
                let allDates = allMoments.map { $0.date }
                let newestMomentDate = allDates.max() //TODO: repository.latestMomentDate(for: relationshipId) oder latestMomentDate(...)

                if let newestMomentDate {
                    rel.lastInteractionDate = newestMomentDate
                    rel.careRhythm.nextReminderDate = Calendar.current.date(
                        byAdding: .day,
                        value: rel.careRhythm.interval,
                        to: newestMomentDate
                    )!
                }

                relationshipService.updateRelationship(rel)
            }
        }
    }

    /// Liefert das Datum des zuletzt gespeicherten Moments einer Beziehung
    ///
    /// Wird nur für die Anzeige gebraucht, nicht für Berechnungen (siehe Relationship)
    func latestMomentDate(for relationshipId: UUID) -> Date? {
        repository.latestMomentDate(for: relationshipId)
    }

    // MARK: - INTERACTION TYPES

    /// Speichert einen neuen Interaktionstyp -> einen vom Nutzer erstellten
    func saveInteractionType(_ type: InteractionType) {
        repository.saveInteractionType(type)
    }

    /// Lädt alle bekannten Interaktionstypen
    func loadInteractionTypes() -> [InteractionType] {
        repository.loadInteractionTypes()
    }

    /// Legt beim ersten App-Start die vordefinierten Interaktionstypen an
    ///
    /// Bereits vorhandene werden übersprungen
    func seedInteractionTypesIfNeeded() {
        let existing = loadInteractionTypes()
        for type in InteractionType.predefined {
            let alreadyExists = existing.contains { $0.name == type.name }
            if !alreadyExists {
                saveInteractionType(type)
            }
        }
    }

    // MARK: - LOAD MOMENTS

    /// Lädt alle Momente einer bestimmten Beziehung
    func loadMoments(for relationshipId: UUID) -> [Moment] {
        repository.loadMoments(for: relationshipId)
    }

    // MARK: - PHOTOS

    /// Speichert ein Foto als JPEG im app-eigenen Dokumente-Verzeichnis und gibt den Dateinamen zurück, der in Moment.photoPath abgelegt wird
    func savePhoto(_ image: UIImage) -> String? {

        let folder = getPhotoFolder()
        let filename = UUID().uuidString + ".jpg"
        let url = folder.appendingPathComponent(filename)

        guard let data = image.jpegData(compressionQuality: 0.8) else {
            return nil
        }
        try? data.write(to: url)
        return filename
    }

    /// Lädt ein Foto anhand seines Dateinamens
    func loadPhoto(_ filename: String) -> UIImage? {
        let url = getPhotoFolder().appendingPathComponent(filename)
        return UIImage(contentsOfFile: url.path)
    }

    /// Löscht ein zuvor gespeichertes Foto
    func deletePhoto(_ filename: String) {
        let url = getPhotoFolder().appendingPathComponent(filename)
        try? FileManager.default.removeItem(at: url)
    }

    private func getPhotoFolder() -> URL {

        let docs = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]

        let dir = docs.appendingPathComponent("MomentPhotos")
        try? FileManager.default.createDirectory(
            at: dir,
            withIntermediateDirectories: true
        )

        return dir
    }
}

//TODO: bilder löschen von der Apple-Sandbox
