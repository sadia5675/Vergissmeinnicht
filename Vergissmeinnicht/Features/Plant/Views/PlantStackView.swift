//
//  PlantStackView.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 02.07.26.
//

import SwiftUI

/// Kombinierte Darstellung aus Pflanze und Topf, überlappend positioniert
struct PlantStackView: View {

    // MARK: - Properties

    let plantType: String
    let pot: String?
    let stage: Int
    let plantSize: CGFloat
    let potSize: CGFloat

    private let imageService = ImageService.shared

    // MARK: - Computed Properties

    private var plantImage: UIImage? {
        imageService.getPlantImage(
            name: plantType,
            stage: stage
        )
    }

    private var potImage: UIImage? {
        guard let pot else {
            return nil
        }
        return imageService.getPotImage(
            name: pot
        )
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: -plantSize * 0.4) {
            if let plantImage {

                Image(uiImage: plantImage)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: plantSize,
                        height: plantSize
                    )
            }

            if let potImage {
                Image(uiImage: potImage)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: potSize,
                        height: potSize
                    )
            }
        }
    }
}

#Preview {
    PlantStackView(
        plantType: "cosmos",
        pot: "pot",
        stage: 3,
        plantSize: 180,
        potSize: 110
    )
    .padding()
    .background(Color("Background"))
}
