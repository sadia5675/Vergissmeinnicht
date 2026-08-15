//
//  AddRelationshipViewModel.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 22.05.26.
//

import Combine
import Foundation

/// Verwaltet die Eingaben und Validierung beim Anlegen einer neuen Beziehung
@MainActor
class AddRelationshipViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var personName = ""
    @Published var phoneNumber = ""
    @Published var birthDate: Date?
    @Published var selectedPlantType: String = "cosmos"
    @Published var selectedPot: String?
    @Published var selectedBackground: String?
    @Published var selectedInterval = 7
    @Published var customReminders: [CustomReminder] = []

    /// Gibt an, ob ein Kontakt aus dem Adressbuch verwendet wird
    @Published var useContact = false

    /// Steuert die Anzeige des Kontakt-Pickers
    @Published var showContactPicker = false

    /// Gibt an, ob ein Geburtstag berücksichtigt werden soll
    @Published var showBirthday = false

    /// Zustand
    @Published var isLoading = false
    @Published var errorMessage: String?

    // MARK: - Dependencies

    private let relationshipService = RelationshipService.shared
    private let imageService = ImageService.shared

    // MARK: - Image Catalog

    /// Verfügbare Pflanzenarten, Töpfe und hintergrüne aus dem Bild-Katalog
    var availablePlants: [ImageCatalogEntry] {
        imageService.loadPlants()
    }
    var availablePots: [ImageCatalogEntry] {
        imageService.loadPots()
    }
    var availableBackgrounds: [ImageCatalogEntry] {
        imageService.loadBackgrounds()
    }

    // MARK: - Save

    /// Validiert die Eingaben und speichert die neue Beziehung
    func saveRelationship() -> Bool {

        guard !personName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Bitte gib einen Namen an."
            return false
        }
        guard !phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Bitte gib eine Telefonnummer an."
            return false
        }
        guard isValidPhoneNumber(phoneNumber) else {
            errorMessage = "Bitte gib eine gültige Telefonnummer an."
            return false
        }
        guard !phoneNumberExists() else {
            errorMessage = "Diese Telefonnummer wurde bereits verwendet."
            return false
        }

        isLoading = true
        defer { isLoading = false }

        let plant = Plant(
            type: selectedPlantType,
            pot: selectedPot,
            background: selectedBackground
        )
        
        let careRhythm = CareRhythm(
            interval: selectedInterval
        )
        
        let relationship = Relationship(
            name: personName,
            phoneNumber: phoneNumber,
            birthDate: showBirthday ? birthDate : nil,
            plant: plant,
            careRhythm: careRhythm,
            customReminders: customReminders
        )
        errorMessage = nil
        relationshipService.createRelationship(relationship)
        
        return true
    }

    // MARK: - Validation

    /// Prüft, ob die eingegebene Telefonnummer erlaubte Zeichen enthält und eine gültige Mindestlänge an Ziffern besitzt
    private func isValidPhoneNumber(_ number: String) -> Bool {

        let allowedCharacters = "0123456789+-() "
        var hasOnlyAllowedCharacters = true

        for character in number {
            if !allowedCharacters.contains(character) {
                hasOnlyAllowedCharacters = false
                break
            }
        }
        let digitCount = number.filter { $0.isNumber }.count
        return hasOnlyAllowedCharacters && digitCount >= 11
    }

    /// Prüft, ob bereits eine Beziehung mit derselben Telefonnummer existiert
   private func phoneNumberExists() -> Bool {
        let current = phoneNumber.filter { $0.isNumber }

        return relationshipService
            .loadRelationships()
            .contains {
                let existing = $0.phoneNumber.filter { $0.isNumber }
                return existing == current
            }
    }

    // MARK: - Contact Picker
    
    /// Übernimmt Name, Telefonnummer und Geburtstag eines ausgewählten Kontakts
    func didSelectContact(
        name: String,
        phone: String?,
        birthday: Date?
    ) {
        personName = name
        phoneNumber = phone ?? ""

        if let birthday {
            birthDate = birthday
            showBirthday = true
        }
    }
}
