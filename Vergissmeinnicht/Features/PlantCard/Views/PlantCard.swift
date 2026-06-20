//
//  PlantCard.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 22.05.26.
//

import SwiftUI

struct PlantCard: View {

    let relationship: Relationship
    var size: PlantCardSize = .small

    private let imageService = ImageService.shared
    private let plantStageService = PlantStageService.shared
    
    @ObservedObject private var motion =
        MotionManager.shared

    private var currentStage: Int {

        let count =
            plantStageService.currentMomentCount(
                for: relationship
            )

        let stage =
            plantStageService.stage(
                for: count
            )

        print("Count:", count)
        print("Stage:", stage)

        return stage
    }

    private var plantImage: UIImage? {

        print(
            "Bild wird geladen mit Stage:",
            currentStage
        )

        return imageService.getPlantImage(
            name: relationship.plant.type,
            stage: currentStage
        )
    }

    private var potImage: UIImage? {
        guard let pot = relationship.plant.pot else {
            return nil
        }

        return imageService.getPotImage(
            name: pot
        )
    }

    private var backgroundImage: UIImage? {
        guard let bg = relationship.plant.background else {
            return nil
        }

        return imageService.getBackgroundImage(
            name: bg
        )
    }
    
    enum PlantCardSize {
        case small
        case large
        
        var plantSize: CGFloat {
            switch self {
            case .small: return 120
            case .large: return 180
            }
        }
        var potSize: CGFloat {
            switch self {
            case .small: return 80
            case .large: return 110
            }
        }
        var cardHeight: CGFloat {
            switch self {
            case .small: return 150
            case .large: return 220
            }
        }
        var titleFont: Font {
            switch self {
            case .small: return .headline
            case .large: return .title
            }
        }
    }
    
    init(
        relationship: Relationship,
        size: PlantCardSize = .small
    ) {
        self.relationship = relationship
        self.size = size
    }
    
    var body: some View {
        ZStack {
            // Hintergrund
            if let image = backgroundImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .opacity(0.35)
            }
            
            VStack(spacing: 12) {
                // Pflanze + Topf
                VStack(spacing: -size.plantSize * 0.4) {
                    if let image = plantImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(
                                width: size.plantSize,
                                height: size.plantSize
                            )
                            .offset(
                                x: motion.x * 6,
                                y: motion.y * 3
                            )
                            .rotationEffect(
                                .degrees(motion.x * 3)
                            )
                            .animation(
                                .easeOut(duration: 0.25),
                                value: motion.x
                            )
                    }
                    if let image = potImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: size.potSize, height: size.potSize)
                    }
                }
                .frame(height: size.cardHeight)
                
                // Name
                Text(relationship.name)
                    .font(size.titleFont)
                    .lineLimit(1)
                
                Text(relationship.status.displayText)
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        relationship.status.backgroundColor
                    )
                    .foregroundColor(
                        relationship.status.color
                    )
                    .clipShape(Capsule())

                
                // Tage
                Text(RelationshipDateFormatter.formatDaysSince(
                    relationship.getDaysSinceLastContact()
                ))
                .font(.caption)
                .foregroundColor(.gray)
                
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
