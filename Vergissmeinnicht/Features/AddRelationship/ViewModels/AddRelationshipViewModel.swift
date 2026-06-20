//
//  AddRelationshipViewModel.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 22.05.26.
//

import Combine
import Foundation

@MainActor
class AddRelationshipViewModel: ObservableObject {
    @Published var personName = ""
    @Published var phoneNumber = ""
    @Published var useContact = false
    @Published var showContactPicker = false
    @Published var selectedPlantType: String = "cosmos"
    @Published var selectedPot: String?
    @Published var selectedBackground: String?
    @Published var selectedInterval = 7
    @Published var birthDate: Date?
    @Published var showBirthday = false
    @Published var isLoading = false
    @Published var customReminders: [CustomReminder] = []
    @Published var errorMessage: String?
    
    private let relationshipService = RelationshipService.shared
    private let imageService = ImageService.shared
    
    // MARK: - Available Images aus DB laden
    
    var availablePlants: [(name: String, displayName: String)] {
        imageService.loadPlants()
    }
    
    var availablePots: [(name: String, displayName: String)] {
        imageService.loadPots()
    }
    
    var availableBackgrounds: [(name: String, displayName: String)] {
        imageService.loadBackgrounds()
    }
    
    func saveRelationship() -> Bool {

        guard !personName.isEmpty else {

            errorMessage =
                "Bitte gib einen Namen an."

            return false
        }

        guard !phoneNumber.isEmpty else {

            errorMessage =
                "Bitte gib eine Telefonnummer an."

            return false
        }

        guard !phoneNumberExists() else {

            errorMessage =
                "Diese Telefonnummer wurde bereits verwendet."

            return false
        }
        
        isLoading = true
        defer { isLoading = false }
        
        print("Speichere Pflanze: \(selectedPlantType)")
        print("Pot: \(selectedPot ?? "nil")")
        print("Background: \(selectedBackground ?? "nil")")
        
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
    
    func phoneNumberExists() -> Bool {

        let current =
            phoneNumber.filter {
                $0.isNumber
            }

        return relationshipService
            .loadRelationships()
            .contains {

                let existing =
                    $0.phoneNumber.filter {
                        $0.isNumber
                    }

                return existing == current
            }
    }
    
    var canSave: Bool {
        !personName.trimmingCharacters(
            in: .whitespaces
        ).isEmpty
        &&
        !phoneNumber.trimmingCharacters(
            in: .whitespaces
        ).isEmpty
    }
}
