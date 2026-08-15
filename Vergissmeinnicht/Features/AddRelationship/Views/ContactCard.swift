//
//  ContactCard.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 28.06.26.
//

import SwiftUI

/// Karte zur Eingabe von Name und Telefonnummer, entweder manuell oder als antippbare Auswahl eines bestehenden Kontakts
struct ContactCard: View {

    enum Mode {
        case manual
        case contact
    }

    // MARK: - Properties

    @Binding var name: String
    @Binding var phone: String

    let mode: Mode
    let onSelectContact: (() -> Void)?

    // MARK: - Body

    var body: some View {

        Group {

            switch mode {

            case .manual:
                content

            case .contact:
                Button {
                    onSelectContact?()

                } label: {
                    content
                }
                .buttonStyle(.plain)
            }
        }
        .foregroundStyle(Color("Primary"))
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color("Surface"))
        .overlay {
            RoundedRectangle(cornerRadius: 22)
                .stroke(
                    Color("Border"),
                    lineWidth: 2
                )
        }
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {

        switch mode {

        case .manual:
            VStack(spacing: 0) {
                TextField(
                    "Name...",
                    text: $name
                )
                .font(.title3)

                Divider()
                    .overlay(Color("Border"))
                    .padding(.vertical, 12)

                TextField(
                    "Telefonnummer...",
                    text: $phone
                )
                .keyboardType(.phonePad)
                .font(.title3)
            }

        case .contact:
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.title2)
                        .foregroundStyle(Color("PrimaryDark"))
                    Text(
                        name.isEmpty
                        ? "Kontakt auswählen"
                        : name
                    )
                    .font(.title3)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
                }

                Divider()
                    .overlay(Color("Border"))
                    .padding(.vertical, 12)

                HStack {
                    Image(systemName: "phone.fill")
                        .foregroundStyle(Color("PrimaryDark"))

                    Text(
                        phone.isEmpty
                        ? "Telefonnummer"
                        : phone
                    )

                    Spacer()
                }
            }
        }
    }
}

#Preview {

    VStack(spacing: 30) {

        ContactCard(
            name: .constant(""),
            phone: .constant(""),
            mode: .manual,
            onSelectContact: nil
        )
    }
    .padding()
    .background(Color("Background"))
}
