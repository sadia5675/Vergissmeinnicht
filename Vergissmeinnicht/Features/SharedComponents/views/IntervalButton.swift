//
//  IntervalButton.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 27.06.26.
//

import SwiftUI

/// Auswählbarer Button für ein festes Pflegeintervall in Tagen
struct IntervalButton: View {

    // MARK: - Properties
    
    let days: Int
    let selected: Bool
    let action: () -> Void

    // MARK: - Body
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text("\(days)").font(.system(size: 16, weight: .semibold))
                Text("Tage").font(.caption)
            }
            .foregroundStyle(Color("PrimaryDark"))
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(
                selected
                ? Color("Secondary")
                : Color("Surface")
            )
            .overlay {
                if !selected {
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(
                            Color("Border"),
                            lineWidth: 2
                        )
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }
}

#Preview {

    VStack(spacing: 12) {
        HStack(spacing: 12) {
            IntervalButton(days: 3, selected: false) {}
            IntervalButton(days: 7, selected: true) {}
        }
        HStack(spacing: 12) {
            IntervalButton(days: 14, selected: false) {}
            IntervalButton(days: 30, selected: false) {}
        }
    }
    .padding()
    .background(Color("Background"))
}
