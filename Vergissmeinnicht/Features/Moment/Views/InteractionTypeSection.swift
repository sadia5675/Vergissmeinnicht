//
//  InteractionTypeSection.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 01.07.26.
//

import SwiftUI

/// Auswahl der Interaktionsart eines Moments und zum Erstellen einer benutzerdefinierten Kategorie
struct InteractionTypeSection: View {

    // MARK: - Properties

    let interactionTypes: [InteractionType]
    
    @Binding var selectedType: InteractionType
    
    let onAddCustom: () -> Void

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Was habt ihr gemacht?")
                .font(.headline.weight(.bold))
                .foregroundStyle(Color("PrimaryDark"))

            ScrollView {
                LazyVGrid(columns: columns, spacing: 14) {
                    ForEach(interactionTypes, id: \.id) { type in

                        Button {
                            selectedType = type

                        } label: {
                            VStack(spacing: 10) {
                                Image(systemName: type.sfSymbol)
                                    .font(.system(size: 22))
                                Text(type.name)
                                    .font(.subheadline.weight(.semibold))
                                    .multilineTextAlignment(.center)
                            }
                            .foregroundStyle(
                                selectedType.id == type.id
                                ? Color.white
                                : Color("PrimaryDark")
                            )
                            .frame(maxWidth: .infinity)
                            .frame(height: 68)
                            .background(
                                selectedType.id == type.id
                                ? Color("PrimaryDark")
                                : Color("Surface")
                            )
                            .overlay {
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(
                                        Color("Border"),
                                        lineWidth: selectedType.id == type.id ? 0 : 2
                                    )
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                        }
                        .buttonStyle(.plain)
                    }

                    Button(action: onAddCustom) {
                        VStack(spacing: 10) {
                            Image(systemName: "plus")
                            Text("Sonstiges")
                                .font(.subheadline.weight(.semibold))
                        }
                        .foregroundStyle(Color("PrimaryDark"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 68)
                        .background(Color.white)
                        .overlay {
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(
                                    Color("Border"),
                                    style: StrokeStyle(
                                        lineWidth: 2,
                                        dash: [8]
                                    )
                                )
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(maxHeight: 220)
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
