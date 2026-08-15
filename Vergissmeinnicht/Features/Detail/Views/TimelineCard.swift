//
//  TimelineCard.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 23.05.26.
//

import SwiftUI

/// Einzelner Eintrag der Momente-Timeline mit Zeitstrahl-Verbindungslinie, Foto, Notiz und beteiligten Personen
struct TimelineCard: View {

    // MARK: - Properties

    let moment: Moment
    let isLast: Bool
    let photo: UIImage?
    let participants: [Relationship]

    // MARK: - Body

    var body: some View {

        HStack(alignment: .top, spacing: 16) {

            // MARK: - Timeline

            VStack(spacing: 0) {
                
                ZStack {
                    Circle()
                        .fill(Color("Primary"))
                        .frame(width: 46, height: 46)

                    Image(systemName: moment.interactionType.sfSymbol)
                        .font(.headline)
                        .foregroundStyle(.white)
                }

                if !isLast {
                    Rectangle()
                        .fill(Color("Primary"))
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                }
            }

            // MARK: - Content

            VStack(alignment: .leading, spacing: 12) {
                Text(moment.interactionType.name)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(Color("PrimaryDark"))
                Text(
                    DateTextFormatter.formatMomentDate(
                        moment.date
                    )
                )
                .font(.caption)
                .foregroundStyle(Color("Primary"))

                if let notes = moment.notes,
                   !notes.isEmpty {
                    Text(notes)
                        .font(.subheadline)
                        .foregroundStyle(Color("PrimaryDark"))
                }

                if let image = photo {
                    ZoomableImage(image: image, cornerRadius: 18, height: 135)
                }

                if participants.count > 1 {
                    ScrollView(
                        .horizontal,
                        showsIndicators: false
                    ) {

                        HStack(spacing: 8) {
                            ForEach(participants) { participant in
                                Text(participant.name)
                                    .font(.caption.weight(.medium))
                                    .foregroundStyle(Color("PrimaryDark"))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(Color("Secondary"))
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
            }
            .padding(14)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .background(Color("Surface"))
            .overlay {

                RoundedRectangle(cornerRadius: 18)
                    .stroke(
                        Color("Border"),
                        lineWidth: 1
                    )
            }
            .clipShape(
                RoundedRectangle(cornerRadius: 18)
            )
        }
        .padding(.vertical, 10)
    }
}
