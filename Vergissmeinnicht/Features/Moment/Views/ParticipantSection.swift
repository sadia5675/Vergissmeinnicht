//
//  ParticipantSection.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 30.06.26.
//

import SwiftUI

/// Mehrfachauswahl der beteiligten Personen in einem Moment
struct ParticipantSection: View {

    // MARK: - Properties

    let relationships: [Relationship]

    @Binding var selectedParticipants: Set<UUID>

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {

            Text("Teilnehmer")
                .font(.headline.weight(.bold))
                .foregroundStyle(Color("PrimaryDark"))

            if relationships.isEmpty {
                Text("Keine weiteren Beziehungen vorhanden.")
                    .foregroundStyle(Color("Primary"))

            } else {

                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(relationships) { relationship in
                            
                            Button {
                                if selectedParticipants.contains(relationship.id) {
                                    selectedParticipants.remove(relationship.id)

                                } else {
                                    selectedParticipants.insert(relationship.id)
                                }

                            } label: {
                                HStack(spacing: 16) {
                                    Circle()
                                        .fill(Color("Secondary"))
                                        .frame(width: 38, height: 38)
                                        .overlay {
                                            Image(systemName: "leaf.fill")
                                                .font(.footnote)
                                                .foregroundStyle(Color("PrimaryDark"))
                                        }
                                    VStack(
                                        alignment: .leading,
                                        spacing: 2
                                    ) {

                                        Text(relationship.name)
                                            .font(.headline)

                                        Text(
                                            DateTextFormatter.formatLastMoment(
                                                relationship.lastMomentDate
                                            )
                                        )
                                        .font(.caption)
                                        .foregroundStyle(Color("Primary"))
                                    }

                                    Spacer()

                                    Image(
                                        systemName:
                                            selectedParticipants.contains(
                                                relationship.id
                                            )
                                        ? "checkmark.circle.fill"
                                        : "circle"
                                    )
                                    .font(.title2)
                                    .foregroundStyle(
                                        selectedParticipants.contains(
                                            relationship.id
                                        )
                                        ? Color("PrimaryDark")
                                        : Color("Border")
                                    )
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 10)
                                .background(Color("Surface"))
                                .overlay {

                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(
                                            Color("Border"),
                                            lineWidth: 2
                                        )
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .frame(maxHeight: 220)
            }
        }
        .padding(20)
        .background(Color.white)
        .overlay {
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color("Border"), lineWidth: 1.5)
        }
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}
