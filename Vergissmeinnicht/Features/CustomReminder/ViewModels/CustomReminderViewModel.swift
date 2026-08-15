//
//  CustomReminderViewModel.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 25.05.26.
//

import Combine
import Foundation

/// ViewModel für das Erstellen, Bearbeiten und Löschen benutzerdefinierter Erinnerungen
@MainActor
class CustomReminderViewModel: ObservableObject {

    // MARK: - Published Properties

    /// Eingabewerte für die Erinnerung
    @Published var label: String = ""
    @Published var date: Date = Date()
    @Published var isActive: Bool = true // TODO: Switch einbauen

    /// Gibt an, ob eine bestehende Erinnerung bearbeitet wird
    @Published var isEditing = false

    /// Zustand
    @Published var isLoading = false
    @Published var errorMessage: String?

    // MARK: - Dependencies

    private let relationshipService = RelationshipService.shared

    /// Beziehung, zu der die Erinnerung gehört
    private let relationship: Relationship?

    /// Bestehende Erinnerung im Bearbeitungsmodus
    private var editingReminder: CustomReminder?

    /// Callback für den Fall, dass eine Erinnerung ohne direkte Beziehung erstellt wird
    private let onSave: ((CustomReminder) -> Void)?

    // MARK: - Initialization

    init(
        relationship: Relationship? = nil,
        editing reminder: CustomReminder? = nil,
        onSave: ((CustomReminder) -> Void)? = nil
    ) {

        self.relationship = relationship
        self.onSave = onSave

        // Bearbeitungsmodus: vorhandene Erinnerung laden
        if let reminder = reminder {
            self.editingReminder = reminder
            self.label = reminder.label
            self.date = reminder.date
            self.isActive = reminder.isActive
            self.isEditing = true

        } else {

            // Erstellmodus: Standarddatum auf den nächsten Tag setzen
            self.date = Calendar.current.date(
                byAdding: .day,
                value: 1,
                to: Date()
            ) ?? Date()
        }
    }

    // MARK: - Save

    /// Erstellt eine neue Erinnerung oder aktualisiert eine bestehende Erinnerung
    func saveCustomReminder() -> Bool {

        guard !label.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Bitte gib einen Erinnerungstitel an."
            return false
        }

        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        // Bearbeitungsmodus: bestehende Erinnerung aktualisieren
        if let editingReminder = editingReminder {

            let updatedReminder = CustomReminder(
                id: editingReminder.id,
                date: date,
                label: label,
                isActive: isActive
            )

            if let relationship {
                relationshipService.updateReminder(
                    updatedReminder,
                    in: relationship
                )

            } else {
                onSave?(updatedReminder)
            }

        } else {

            // Erstellmodus: neue Erinnerung anlegen
            let reminder = CustomReminder(
                date: date,
                label: label,
                isActive: isActive
            )

            if let relationship {
                // Erinnerung direkt zu einer Beziehung hinzufügen
                relationshipService.addReminder(
                    reminder,
                    to: relationship
                )

            } else {
                // Erinnerung über Callback zurückgeben
                onSave?(reminder)
            }
        }

        return true
    }

    // MARK: - Delete

    /// Entfernt eine bestehende benutzerdefinierte Erinnerung
    func delete() {

        guard let editingReminder else {
            return
        }

        guard let relationship else {
            return
        }

        isLoading = true
        defer { isLoading = false }

        relationshipService.deleteReminder(
            editingReminder,
            from: relationship
        )

        print("Reminder gelöscht: \(editingReminder.label)")
    }

    /// Gibt an, ob die Erinnerung gelöscht werden kann
    var canDelete: Bool {
        relationship != nil
    }
}
