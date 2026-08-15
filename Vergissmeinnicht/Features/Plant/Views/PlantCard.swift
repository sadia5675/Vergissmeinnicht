//
//  PlantCard.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 22.05.26.
//

import SwiftUI

/// Karte einer Beziehung in der Gartenübersicht: zeigt Pflanze, Name, Status-Chip und den Zeitpunkt des letzten Moments an
struct PlantCard: View {
    
    // MARK: - Size

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

    // MARK: - Properties

    private let relationship: Relationship
    private var size: PlantCardSize = .small
    private let showName: Bool
    private let imageService = ImageService.shared
    private let plantStageService = PlantStageService.shared

    // MARK: - Computed Properties

    private var currentStage: Int {
        plantStageService.calculateStage(for: relationship)
    }
    
    private var backgroundImage: UIImage? {
        guard let bg = relationship.plant.background else {
            return nil
        }
        return imageService.getBackgroundImage(name: bg)
    }

    // MARK: - Init

    init(
        relationship: Relationship,
        size: PlantCardSize = .small,
        showName: Bool = true
    ) {
        self.relationship = relationship
        self.size = size
        self.showName = showName
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 12) {
            PlantStackView(
                plantType: relationship.plant.type,
                pot: relationship.plant.pot,
                stage: currentStage,
                plantSize: size.plantSize,
                potSize: size.potSize
            )
            .frame(height: size.cardHeight)

            if showName {
                Text(relationship.name)
                    .font(size.titleFont)
                    .lineLimit(1)
            }
            Text(relationship.status.displayText)
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(
                    relationship.status.chipBackground
                )
                .foregroundColor(
                    relationship.status.chipForeground
                )
                .clipShape(Capsule())

            Text(DateTextFormatter.formatLastMoment(
                relationship.lastMomentDate
            ))
            .font(.caption)
            .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background {

            ZStack {
                Color("Surface")
                if let backgroundImage {
                    Image(uiImage: backgroundImage)
                        .resizable()
                        .scaledToFill()
                        .opacity(0.35)
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
