//
//  ContactPicker.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 07.06.26.
//

import SwiftUI
import ContactsUI

struct ContactPicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let onContactPicked: (String, String?) -> Void

    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()  // ← leerer Host-Controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented && uiViewController.presentedViewController == nil {
            let picker = CNContactPickerViewController()
            picker.delegate = context.coordinator
            uiViewController.present(picker, animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(isPresented: $isPresented, onContactPicked: onContactPicked)
    }

    class Coordinator: NSObject, CNContactPickerDelegate {
        @Binding var isPresented: Bool
        let onContactPicked: (String, String?) -> Void

        init(isPresented: Binding<Bool>, onContactPicked: @escaping (String, String?) -> Void) {
            self._isPresented = isPresented
            self.onContactPicked = onContactPicked
        }

        func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
            let name = "\(contact.givenName) \(contact.familyName)"
                .trimmingCharacters(in: .whitespaces)
            let phone = contact.phoneNumbers.first?.value.stringValue
            onContactPicked(name, phone)
            isPresented = false
        }

        func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
            isPresented = false
        }
    }
}
