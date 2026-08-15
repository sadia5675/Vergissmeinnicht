//
//  GardenTabBar.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 28.06.26.
//

import SwiftUI

enum GardenTab {
    case wellCared
    case needsAttention
    case resting
}

/// Chip-Leiste zum Filtern der Gartenübersicht nach Kategorie
struct GardenTabBar: View {

    // MARK: - Properties

    @Binding var selectedTab: GardenTab

    // MARK: - Body

    var body: some View {

        HStack(spacing: 10) {
            chip(
                "Gut gepflegt",
                .wellCared
            )
            chip(
                "Wartet auf dich",
                .needsAttention
            )
            chip(
                "Ruhezustand",
                .resting
            )
            Spacer()
        }
    }

    // MARK: - Chip

    @ViewBuilder
    private func chip(
        _ title: String,
        _ tab: GardenTab
    ) -> some View {

        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedTab = tab
            }

        } label: {
            Text(title)
                .font(.caption.weight(.semibold))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.7)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .padding(.horizontal, 8)
                .background(
                    selectedTab == tab
                    ? Color("Secondary")
                    : Color("Surface")
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color("Border"), lineWidth: 2)
                }
                .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .buttonStyle(.plain)
    }
}
