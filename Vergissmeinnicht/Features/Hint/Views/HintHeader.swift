//
//  HintHeader.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 02.07.26.
//

import SwiftUI

/// Gemeinsamer Header für Hint-Karten mit Status-Chip und Schließen-Button
struct HintHeader: View {

    // MARK: - Properties

    let status: RelationshipStatus
    let dismissColor: Color
    let onDismiss: () -> Void

    // MARK: - Body

    var body: some View {
        HStack {
            Text(status.displayText)
                .font(.caption.weight(.semibold))
                .foregroundStyle(status.chipForeground)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(status.chipBackground)
                .clipShape(Capsule())
            
            Spacer()

            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.headline)
                    .foregroundStyle(dismissColor)
            }
        }
    }
}
