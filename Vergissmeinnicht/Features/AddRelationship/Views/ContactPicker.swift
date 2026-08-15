//
//  ContactPicker.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 07.06.26.
//

import SwiftUI
import ContactsUI

/// UIKit-Wrapper um CNContactPickerViewController zur Übernahme eines Kontakts aus dem Adressbuch
struct ContactPicker: UIViewControllerRepresentable {

    // MARK: - Properties

    @Binding var isPresented: Bool

    let onContactPicked: (
        String,
        String?,
        Date?
    ) -> Void

    // MARK: - UIViewControllerRepresentable

    /// Erstellt einen leeren Anker-Controller, der als Präsentationspunkt dient, da CNContactPickerViewController von einem vorhandenen UIViewController geöffnet werden muss
    func makeUIViewController(
        context: Context
    ) -> UIViewController {

        UIViewController()
    }

    /// Zeigt den Kontakt-Picker an, sobald isPresented aktiviert ist und noch kein Picker geöffnet wurde
    func updateUIViewController(
        _ uiViewController: UIViewController,
        context: Context
    ) {

        if isPresented &&
            uiViewController.presentedViewController == nil {

            let picker = CNContactPickerViewController()

            // Lädt nur die benötigten Kontaktdaten
            picker.displayedPropertyKeys = [
                CNContactGivenNameKey,
                CNContactFamilyNameKey,
                CNContactPhoneNumbersKey,
                CNContactBirthdayKey
            ]

            picker.delegate = context.coordinator

            uiViewController.present(
                picker,
                animated: true
            )
        }
    }

    func makeCoordinator() -> Coordinator {

        Coordinator(
            isPresented: $isPresented,
            onContactPicked: onContactPicked
        )
    }

    // MARK: - Coordinator

    /// Übernimmt die Kommunikation zwischen dem UIKit-Kontaktpicker und SwiftUI, speichert den ausgewählten Kontakt und schließt den Picker danach
    class Coordinator:
        NSObject,
        CNContactPickerDelegate {

        @Binding var isPresented: Bool

        let onContactPicked: (
            String,
            String?,
            Date?
        ) -> Void

        init(
            isPresented: Binding<Bool>,
            onContactPicked: @escaping (
                String,
                String?,
                Date?
            ) -> Void
        ) {

            self._isPresented = isPresented
            self.onContactPicked = onContactPicked
        }

        /// Wird von UIKit aufgerufen, sobald der Nutzer einen Kontakt auswählt
        func contactPicker(
            _ picker: CNContactPickerViewController,
            didSelect contact: CNContact
        ) {
            let name =
                "\(contact.givenName) \(contact.familyName)"
                    .trimmingCharacters(in: .whitespaces)

            let phone =
                contact.phoneNumbers
                    .first?
                    .value
                    .stringValue

            let birthday =
                contact.birthday.flatMap {
                    Calendar.current.date(from: $0)
                }
            onContactPicked(
                name,
                phone,
                birthday
            )
            isPresented = false
        }

        /// Wird aufgerufen, wenn der Nutzer den Picker ohne Auswahl abbricht
        func contactPickerDidCancel(
            _ picker: CNContactPickerViewController
        ) {
            isPresented = false
        }
    }
}
