//
//  TimelineCard.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 23.05.26.
//

import SwiftUI

struct TimelineCard: View {
    let moment: Moment
    let isLast: Bool
    let photo: UIImage?
    let participants: [Relationship]

    var body: some View {

        HStack(alignment: .top, spacing: 16) {

            // MARK: Timeline links

            VStack(spacing: 0) {

                ZStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 60, height: 60)

                    Image(systemName: moment.type.sfSymbol)
                        .font(.title2)
                        .foregroundColor(.white)
                }

                if !isLast {
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: 3)
                        .frame(maxHeight: .infinity)
                }
            }

            // MARK: Inhalt rechts

            VStack(
                alignment: .leading,
                spacing: 8
            ) {

                Text(moment.type.name)
                    .font(.title3)
                    .fontWeight(.bold)

                if let notes = moment.notes,
                   !notes.isEmpty {

                    Text(notes)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                if !participants.isEmpty {

                    ScrollView(.horizontal, showsIndicators: false) {

                        HStack {

                            ForEach(participants) { participant in

                                Text(participant.name)
                                    .font(.caption)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(
                                        Color.green.opacity(0.15)
                                    )
                                    .cornerRadius(12)
                            }
                        }
                    }
                }

                if let image = photo {

                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 180)
                        .clipped()
                        .cornerRadius(12)
                }

                Text(relativeDate)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
        }
        .padding(.vertical, 12)
    }

    private var relativeDate: String {

        let days =
            Calendar.current.dateComponents(
                [.day],
                from: moment.date,
                to: Date()
            ).day ?? 0

        if days == 0 {
            return "Heute"
        }

        if days == 1 {
            return "Gestern"
        }

        return "vor \(days) Tagen"
    }
}
