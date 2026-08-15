//
//  PlantCustomizationView.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 26.06.26.
//

import SwiftUI

enum CustomizationTab {

    case plant
    case pot
    case background
}

/// Ansicht zur Personalisierung einer Pflanze über drei Tabs (Pflanze, Topf, Hintergrund)
struct PlantCustomizationView: View {

    // MARK: - Properties

    @State private var selectedPlant: String
    @State private var selectedPot: String?
    @State private var selectedBackground: String?
    @State private var selectedTab: CustomizationTab

    private let canChangePlant: Bool
    private let availablePlants: [ImageCatalogEntry]
    private let availablePots: [ImageCatalogEntry]
    private let availableBackgrounds: [ImageCatalogEntry]

    let onSave: (String, String?, String?) -> Void

    @Environment(\.dismiss) private var dismiss

    // MARK: - Init

    init(
        selectedPlant: String,
        selectedPot: String?,
        selectedBackground: String?,
        canChangePlant: Bool = true,
        availablePlants: [ImageCatalogEntry],
        availablePots: [ImageCatalogEntry],
        availableBackgrounds: [ImageCatalogEntry],
        onSave: @escaping (String, String?, String?) -> Void
    ) {
        _selectedPlant = State(initialValue: selectedPlant)
        _selectedPot = State(initialValue: selectedPot)
        _selectedBackground = State(initialValue: selectedBackground)
        self.canChangePlant = canChangePlant
        self.availablePlants = availablePlants
        self.availablePots = availablePots
        self.availableBackgrounds = availableBackgrounds
        self.onSave = onSave

        if canChangePlant {
            _selectedTab = State(initialValue: .plant)
        } else {
            _selectedTab = State(initialValue: .pot)
        }
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()

            VStack(spacing: 20) {

                // Vorschau
                PlantPreviewCard(
                    plant: Plant(
                        type: selectedPlant,
                        pot: selectedPot,
                        background: selectedBackground
                    )
                )

                // Tabs
                CustomizationTabBar(
                    selectedTab: $selectedTab,
                    canChangePlant: canChangePlant
                )

                // Grid
                switch selectedTab {

                case .plant:

                    CustomizationGrid(
                        items: availablePlants,
                        selectedName: selectedPlant,
                        onSelect: {
                            if let name = $0 {
                                selectedPlant = name
                            }
                        },
                        allowNone: false,
                        noneLabel: "",
                        type: .plant,
                        previewStage: 3
                    )

                case .pot:

                    CustomizationGrid(
                        items: availablePots,
                        selectedName: selectedPot,
                        onSelect: { selectedPot = $0 },
                        allowNone: true,
                        noneLabel: "Kein Topf",
                        type: .pot
                    )

                case .background:

                    CustomizationGrid(
                        items: availableBackgrounds,
                        selectedName: selectedBackground,
                        onSelect: { selectedBackground = $0 },
                        allowNone: true,
                        noneLabel: "Kein Hintergrund",
                        type: .background
                    )
                }
            }
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {

            ToolbarItem(placement: .topBarLeading) {
                Button("Abbrechen") {
                    dismiss()
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button("Fertig") {

                    onSave(
                        selectedPlant,
                        selectedPot,
                        selectedBackground
                    )

                    dismiss()
                }
                .fontWeight(.semibold)
            }
        }
    }
}
