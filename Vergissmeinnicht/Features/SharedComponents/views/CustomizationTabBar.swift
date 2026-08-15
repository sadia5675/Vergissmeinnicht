//
//  CustomizationTabBar.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 28.06.26.
//

import SwiftUI

/// Tab-Leiste zum Wechseln zwischen Pflanze, Topf und Hintergrund innerhalb der Personalisierungsansicht
struct CustomizationTabBar: View {

    // MARK: - Properties
    @Binding var selectedTab: CustomizationTab
    let canChangePlant: Bool

    // MARK: - Body
    
    var body: some View {
        HStack(spacing: 12) {
            if canChangePlant {

                SecondaryButton(
                    title: "Pflanze",
                    selected: selectedTab == .plant
                ) {
                    selectedTab = .plant
                }
            }

            SecondaryButton(
                title: "Topf",
                selected: selectedTab == .pot
            ) {
                selectedTab = .pot
            }

            SecondaryButton(
                title: "Hintergrund",
                selected: selectedTab == .background
            ) {
                selectedTab = .background
            }
        }
    }
}
