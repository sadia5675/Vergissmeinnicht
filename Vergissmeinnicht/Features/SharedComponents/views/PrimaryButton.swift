//
//  Button.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 27.06.26.
//

import SwiftUI

/// Hervorgehobener, primärer Button für die wichtigste Aktion
struct PrimaryButton: View {

    // MARK: - Properties
    
    let title: String
    let selected: Bool
    let action: () -> Void

    var body: some View {

        // MARK: - Body
        
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .minimumScaleFactor(0.8)
                .lineLimit(1)
                .foregroundStyle(
                    selected
                    ? Color("Surface")
                    : Color("PrimaryDark")
                )
                .frame(maxWidth: .infinity)
                .frame(minHeight: 52)
                .background(
                    selected
                    ? Color("PrimaryDark")
                    : Color("Surface")
                )
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview("Primary") {
    VStack(spacing: 20) {
        PrimaryButton(
            title: "Kontakte verwenden",
            selected: true
        ) {}

        PrimaryButton(
            title: "Kontakte verwenden",
            selected: false
        ) {}
    }
    .padding()
    .background(Color("Background"))
}
