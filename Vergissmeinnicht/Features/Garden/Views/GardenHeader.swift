//
//  GardenHeader.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 29.06.26.
//

import SwiftUI

/// Kopfbereich der Gartenübersicht mit editierbarem Gartennamen sowie Schaltflächen zum Hinzufügen einer Beziehung und Festhalten eines Moments
struct GardenHeader: View {

    // MARK: - Properties

    @ObservedObject var viewModel: GardenViewModel
    @Binding var showAddRelationship: Bool
    @Binding var showQuickMoment: Bool
    @Binding var editingGardenName: Bool
    @Binding var gardenName: String
    @FocusState.Binding var nameFocused: Bool

    // MARK: - Body

    var body: some View {

        HStack {
            VStack(alignment: .leading, spacing: 2) {
                if editingGardenName {
                    TextField(
                        "Gartenname",
                        text: $gardenName
                    )
                    .focused($nameFocused)
                    .font(.largeTitle.bold())
                    .textFieldStyle(.plain)
                    .submitLabel(.done)
                    .onSubmit {
                        let trimmed = gardenName
                            .trimmingCharacters(
                                in: .whitespacesAndNewlines
                            )
                        if !trimmed.isEmpty {
                            viewModel.updateGardenName(trimmed)
                        }
                        editingGardenName = false
                    }

                } else {
                    HStack(spacing: 6) {
                        Text(viewModel.gardenName)
                            .font(.largeTitle.bold())

                        Image(systemName: "pencil")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(Color("Primary"))
                    }
                    .onTapGesture {
                        gardenName = viewModel.gardenName
                        editingGardenName = true
                        nameFocused = true
                    }
                }

                Text("\(viewModel.relationships.count) Beziehungen")
                    .font(.caption)
                    .foregroundStyle(Color("Primary"))
            }

            Spacer()

            HStack(spacing: 10) {

                Button {
                    showQuickMoment = true
                } label: {
                    Image("momentIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .frame(width: 50, height: 50)
                        .background(Color("PrimaryDark"))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }

                Button {
                    showAddRelationship = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(Color("PrimaryDark"))
                        .frame(width: 50, height: 50)
                        .background(Color("Surface"))
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color("Border"), lineWidth: 2)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 12)
        .padding(.bottom, 12)
    }
}
