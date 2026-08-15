//
//  RelationshipHintCard.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 29.06.26.
//

import SwiftUI

/// Hint-Karte für Beziehungen im Zustand "Braucht Pflege" oder "Vermisst dich", mit basierend auf einen gespeicherten Moment oder einen Nachrichtenvorschlag
struct RelationshipHintCard: View {

    // MARK: - Properties

    let hint: Hint
    let onDismiss: () -> Void

    @State private var showMessageSheet = false

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

            // MARK: - Header

            HintHeader(
                status: hint.relationshipStatus,
                dismissColor: Color("Primary"),
                onDismiss: onDismiss
            )

            VStack(alignment: .leading, spacing: 4) {
                Text(hint.relationship.name)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(Color("PrimaryDark"))
                Text(
                    DateTextFormatter.formatLastMoment(
                        hint.relationship.lastMomentDate
                    )
                )
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color("Primary"))
            }

            // MARK: - Main Text

            Text(hint.displayContent)
                .font(.subheadline)
                .foregroundStyle(Color("PrimaryDark"))
            Rectangle()
                .fill(Color("Primary"))
                .frame(height: 2)

            // MARK: - Photo or Message

            if let photoPath = hint.sourceMoment?.photoPath,
               let image = MomentService.shared.loadPhoto(photoPath) {
                ZoomableImage(image: image, cornerRadius: 22, height: 170)
                
            } else if let message = hint.prefilledMessage {
                VStack(alignment: .leading, spacing: 10) {
                    Text("MÖGLICHE NACHRICHT")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color("Primary"))
                    Text("\"\(message)\"")
                        .font(.subheadline)
                        .foregroundStyle(Color("PrimaryDark"))
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color("Background"))
                .clipShape(RoundedRectangle(cornerRadius: 22))
            }

            // MARK: - Button

            if hint.relationship.phoneNumber != nil {
                PrimaryButton(
                    title: "Nachricht schreiben",
                    selected: true
                ) {
                    showMessageSheet = true
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .sheet(isPresented: $showMessageSheet) {
            MessageComposer(
                recipients: [hint.relationship.phoneNumber ?? ""],
                body: hint.prefilledMessage ?? ""
            )
        }
    }
}
