//
//  InfoCard.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 30.06.26.
//

import SwiftUI

/// Zeigt Name, Telefonnummer und letzten Kontakt einer Beziehung an oder erlaubt deren Bearbeitung
struct InfoCard: View {

    // MARK: - Properties

    let relationship: Relationship
    let isEditing: Bool

    @Binding var editName: String
    @Binding var editPhone: String
    @Binding var editInterval: Int

    // MARK: - Body

    var body: some View {

        VStack(alignment: .leading, spacing: 18) {
            Text("Informationen")
                .font(.headline.weight(.bold))
                .foregroundStyle(Color("PrimaryDark"))

            infoRow(
                icon: "person",
                title: "Name"
            ) {
                if isEditing {
                    TextField(
                        "Name",
                        text: $editName
                    )
                    .multilineTextAlignment(.trailing)

                } else {
                    Text(relationship.name)
                        .fontWeight(.semibold)
                }
            }
            Divider()

            infoRow(
                icon: "phone",
                title: "Telefon"
            ) {
                if isEditing {
                    TextField(
                        "Telefon",
                        text: $editPhone
                    )
                    .keyboardType(.phonePad)
                    .multilineTextAlignment(.trailing)

                } else {
                    Text(
                        relationship.phoneNumber.isEmpty
                        ? "Nicht hinterlegt"
                        : relationship.phoneNumber
                    )
                    .fontWeight(.semibold)
                }
            }
            Divider()

            infoRow(
                icon: "calendar",
                title: "Letzter Kontakt"
            ) {
                Text(
                    DateTextFormatter.formatLastMoment(
                        relationship.lastMomentDate
                    )
                )
                .fontWeight(.semibold)
            }
        }
        .padding(20)
        .background(Color.white)
        .overlay {
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color("Border"), lineWidth: 1.5)
        }
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    // MARK: - Info Row

    @ViewBuilder
    func infoRow<Content: View>(
        icon: String,
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        
        HStack {
            Label(
                title,
                systemImage: icon
            )
            Spacer()

            content()
        }
    }
}

