//
//  PlantSection.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 28.06.26.
//

import SwiftUI

/// Zeigt die Pflanzenvorschau beim Anlegen einer Beziehung und öffnet bei Bedarf die Personalisierungsansicht
struct PlantSection: View {

    // MARK: - Properties

    @ObservedObject var viewModel: AddRelationshipViewModel
    @Binding var showCustomization: Bool

    // MARK: - Body

    var body: some View {
        VStack {
            PlantPreviewCard(
                plant: Plant(
                    type: viewModel.selectedPlantType,
                    pot: viewModel.selectedPot,
                    background: viewModel.selectedBackground
                )
            )
            .contentShape(Rectangle())
            .onTapGesture {
                showCustomization = true
            }
            PrimaryButton(
                title: "Pflanze personalisieren",
                selected: false
            ) {
                showCustomization = true
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .padding(.top)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
