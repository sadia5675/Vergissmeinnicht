//
//  CustomReminderViewModel.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 25.05.26.
//

import Combine
import Foundation

@MainActor
class CustomReminderViewModel: ObservableObject {

    // MARK: - PUBLISHED
    @Published var label: String = ""
    @Published var date: Date = Date()
    @Published var isActive: Bool = true
    @Published var isLoading = false
    @Published var isEditing = false

    // MARK: - PROPERTIES

    private let relationship: Relationship?

    private let relationshipService =
        RelationshipService.shared

    private var editingReminder:
        CustomReminder?
    
    private let onSave: ((CustomReminder) -> Void)?

    // MARK: - INIT

    init(
        relationship: Relationship? = nil,
        editing reminder: CustomReminder? = nil,
        onSave: ((CustomReminder) -> Void)? = nil
    ) {

        self.relationship = relationship
        self.onSave = onSave

        // EDIT MODE
        if let reminder = reminder {

            self.editingReminder = reminder

            self.label = reminder.label

            self.date = reminder.date

            self.isActive = reminder.isActive

            self.isEditing = true

        } else {

            // CREATE MODE
            self.date = Calendar.current.date(
                byAdding: .day,
                value: 1,
                to: Date()
            ) ?? Date()
        }
    }

    // MARK: - SAVE

    func save() {

        guard !label.isEmpty else {
            return
        }

        isLoading = true

        if let editingReminder = editingReminder {
            
            guard let relationship else {
                   return
               }

            let updatedReminder =
                CustomReminder(
                    id: editingReminder.id,
                    date: date,
                    label: label,
                    isActive: isActive
                )

            relationshipService
                .updateReminder(
                    updatedReminder,
                    in: relationship
                )

            print(
                "Reminder aktualisiert: \(label)"
            )

        } else {

            let reminder = CustomReminder(
                date: date,
                label: label,
                isActive: isActive
            )

            if let relationship {

                relationshipService.addReminder(
                    reminder,
                    to: relationship
                )

            } else {

                onSave?(reminder)
            }

            print(
                "Reminder hinzugefügt: \(label)"
            )
        }

        isLoading = false
    }

    // MARK: - DELETE

    func delete() {

        guard let editingReminder = editingReminder else {
            return
        }

        guard let relationship = relationship else {
            return
        }

        isLoading = true

        relationshipService
            .deleteReminder(
                editingReminder,
                from: relationship
            )

        print(
            "Reminder gelöscht: \(editingReminder.label)"
        )

        isLoading = false
    }
}
