//
//  DashedButton.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 27.06.26.
//

import SwiftUI

/// Button mit gestricheltem Rahmen
struct DashedButton: View {

    // MARK: - Properties
    
    let title: String
    let action: () -> Void

    // MARK: - Body
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundStyle(Color("Primary"))
                .frame(maxWidth: .infinity)
                .frame(minHeight: 60)
                .background(Color("Surface"))
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .overlay {
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(
                            Color("Border"),
                            style: StrokeStyle(
                                lineWidth: 2,
                                dash: [8]
                            )
                        )
                }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack {
        DashedButton(title: "Weitere Termine hinzufügen...") {}
    }
    .padding()
    .background(Color("Background"))
}
