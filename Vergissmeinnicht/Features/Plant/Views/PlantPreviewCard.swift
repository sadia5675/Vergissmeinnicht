//
//  PlantPreviewCard.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 26.06.26.
//

import SwiftUI

/// Vorschau der Pflanze über alle vier Wachstumsstufen, durchblätterbar durch Wischgeste
struct PlantPreviewCard: View {

    // MARK: - Properties

    let plant: Plant
    
    private let imageService = ImageService.shared
    @State private var previewStage = 0

    // MARK: - Computed Properties

    private var backgroundImage: UIImage? {

        guard let background = plant.background else {
            return nil
        }

        return imageService.getBackgroundImage(name: background)
    }

    // MARK: - Body

    var body: some View {

        VStack(spacing: 16) {

            TabView(selection: $previewStage) {

                ForEach(0...3, id: \.self) { stage in

                    ZStack {
                        Color("Background")

                        if let image = backgroundImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .clipped()
                        }

                        PlantStackView(
                            plantType: plant.type,
                            pot: plant.pot,
                            stage: stage,
                            plantSize: 180,
                            potSize: 110
                        )
                        .frame(height: 220)
                    }
                    .frame(height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal)
                    .tag(stage)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .frame(height: 240)

            VStack(spacing: 4) {

                Text("Wachstumsstufe \(previewStage + 1) von 4")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
