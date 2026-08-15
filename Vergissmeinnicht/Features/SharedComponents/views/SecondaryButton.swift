//
//  SecondaryButton.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 27.06.26.
//

import SwiftUI

/// Zweitrangiger Button
struct SecondaryButton: View {

    // MARK: - Properties
    
    let title: String
    let selected: Bool
    let action: () -> Void

    // MARK: - Body
    
    var body: some View {

        Button(action: action) {

            Text(title)
                .font(.subheadline.weight(.semibold))
                .minimumScaleFactor(0.8)
                .lineLimit(1)
                .foregroundStyle(
                    selected
                    ? Color("PrimaryDark")
                    : Color("Primary")
                )
                .frame(maxWidth: .infinity)
                .frame(minHeight: 52)
                .background(
                    selected
                    ? Color("Secondary")
                    : Color("Surface")
                )
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .overlay {
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(
                            Color("Border"),
                            lineWidth: 2
                        )
                }
        }
        .buttonStyle(.plain)
    }
}

#Preview("Secondary") {

    VStack(spacing: 20) {

        SecondaryButton(
            title: "Kontakte verwenden",
            selected: true
        ) {}

        SecondaryButton(
            title: "Kontakte verwenden",
            selected: false
        ) {}
    }
    .padding()
    .background(Color("Background"))
}
