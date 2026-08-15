//
//  ContactSection.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 28.06.26.
//

//
//  ContactSection.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 28.06.26.
//

import SwiftUI

/// Auswahl zwischen manueller Eingabe und Kontaktübernahme beim Anlegen einer neuen Beziehung
struct ContactSection: View {

    // MARK: - Properties

    @ObservedObject var viewModel: AddRelationshipViewModel

    // MARK: - Body

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                SecondaryButton(
                    title: "Kontakte verwenden",
                    selected: viewModel.useContact
                ) {
                    viewModel.useContact = true
                    viewModel.showContactPicker = true
                }
                SecondaryButton(
                    title: "Manuell eingeben",
                    selected: !viewModel.useContact
                ) {
                    viewModel.useContact = false
                }
            }

            ContactCard(
                name: $viewModel.personName,
                phone: $viewModel.phoneNumber,
                mode: viewModel.useContact ? .contact : .manual,
                onSelectContact: {
                    viewModel.showContactPicker = true
                }
            )

            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    ContactSection(
        viewModel: {
            let vm = AddRelationshipViewModel()
            vm.useContact = false
            vm.personName = "Test"
            vm.phoneNumber = "+49 176 12345678"
            return vm
        }()
    )
    .padding()
    .background(Color("Background"))
}
