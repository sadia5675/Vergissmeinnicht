//
//  HintView.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 23.05.26.
//

import SwiftUI

/// Wählt anhand des Beziehungsstatus die passende Hint-Karte aus
struct HintView: View {

    // MARK: - Properties

    let hint: Hint
    var onDismiss: () -> Void = {}

    // MARK: - Body

    var body: some View {

        switch hint.relationshipStatus {

        case .blooming:
            BloomingHintCard(
                hint: hint,
                onDismiss: onDismiss
            )

        case .needsCare,.missesYou:
            RelationshipHintCard(
                hint: hint,
                onDismiss: onDismiss
            )
        }
    }
}

#Preview {
    HintView(
        hint: Hint(
            relationship: Relationship(
                name: "Anna Haro",
                phoneNumber: "0170123456",
                plant: Plant(type: "cosmos"),
                careRhythm: CareRhythm(interval: 7)
            ),
            relationshipStatus: .needsCare,
            displayContent: "Anna hat schon länger nichts von dir gehört.",
            prefilledMessage: "Hey Anna, wollte mich mal wieder melden..."
        ),
        onDismiss: {}
    )
    .padding()
    .background(Color("Background"))
}
