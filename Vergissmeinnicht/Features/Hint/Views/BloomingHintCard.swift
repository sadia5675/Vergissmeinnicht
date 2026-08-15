//
//  BloomingHintCard.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 29.06.26.
//

import SwiftUI

/// Hint-Karte für Beziehungen im Zustand "Blüht", mit wertschätzendem Text auf dunklem Hintergrund
struct BloomingHintCard: View {

    // MARK: - Properties

    let hint: Hint
    let onDismiss: () -> Void

    // MARK: - Body

    var body: some View {

        VStack(alignment: .leading, spacing: 18) {
            HintHeader(
                status: hint.relationshipStatus,
                dismissColor: Color("Secondary"),
                onDismiss: onDismiss
            )
            Text(hint.displayContent)
                .font(.title3.weight(.bold))
                .foregroundStyle(.white)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("PrimaryDark"))
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}
