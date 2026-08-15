//
//  MomentView.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 23.05.26.
//

import SwiftUI

/// Formular zum Festhalten eines Moments, sowie Auslösen und Verwaltung der Wachstums-Animation nach dem Speichern
struct MomentView: View {

    // MARK: - Properties

    @StateObject var viewModel: MomentViewModel
    
    @Environment(\.dismiss) private var dismiss

    @State private var showCustomTypePicker = false
    @State private var showImagePicker = false
    @State private var showGrowthView = false
    @State private var growthQueue: [GrowthItem] = []

    var showHeader: Bool = true

    // MARK: - Body

    var body: some View {
        NavigationStack {

            ScrollView {
                VStack(alignment: .leading, spacing: 28) {

                    // MARK: - Header (nur wenn eine feste Person vorgegeben ist)

                    if showHeader,
                       let relationship = viewModel.preselectedRelationship {

                        HStack(spacing: 16) {
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color("Secondary"))
                                .frame(width: 72, height: 72)
                                .overlay {
                                    Image(systemName: "leaf.fill")
                                        .font(.system(size: 32))
                                        .foregroundStyle(Color("PrimaryDark"))
                                }

                            VStack(alignment: .leading) {
                                Text(relationship.name)
                                    .font(.headline)

                                Text("Halte einen gemeinsamen Moment fest")
                                    .foregroundStyle(Color("Primary"))
                            }

                            Spacer()
                        }
                        .padding()
                        .background(Color.white)
                        .overlay {
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color("Border"), lineWidth: 1.5)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                    }

                    // MARK: - Participants

                    ParticipantSection(
                        relationships: viewModel.allRelationships,
                        selectedParticipants: $viewModel.selectedParticipants
                    )

                    // MARK: - Interaction Type

                    InteractionTypeSection(
                        interactionTypes: viewModel.interactionTypes,
                        selectedType: $viewModel.selectedInteractionType,
                        onAddCustom: {
                            showCustomTypePicker = true
                        }
                    )

                    // MARK: - Photo

                    PhotoSection(image: $viewModel.selectedImage)

                    // MARK: - Date

                    VStack(alignment: .leading, spacing: 18) {
                        DateTimeCard(
                            date: $viewModel.selectedDate,
                            maxDate: Date()
                        )
                    }
                    .padding(20)
                    .background(Color.white)
                    .overlay {
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color("Border"), lineWidth: 1.5)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 24))

                    // MARK: - Notes

                    NotesSection(
                        notes: $viewModel.notes,
                        templates: viewModel.noteTemplates
                    )

                    // MARK: - Save Button

                    PrimaryButton(
                        title: viewModel.isLoading
                        ? "Speichern..."
                        : "Moment speichern",
                        selected: true
                    ) {
                        save()
                    }
                    .disabled(
                        viewModel.isLoading ||
                        viewModel.selectedParticipants.isEmpty
                    )
                }
                .padding()
            }
            .background(Color("Background"))
            .sheet(isPresented: $showCustomTypePicker) {
                CustomInteractionTypeView { newType in
                    viewModel.loadInteractionTypes()
                    viewModel.selectedInteractionType = newType
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Abbrechen") {
                        dismiss()
                    }
                }
            }
            .fullScreenCover(isPresented: $showGrowthView) {
                if let current = growthQueue.first {
                    GrowthView(
                        oldImage: current.oldImage,
                        newImage: current.newImage,
                        relationshipName: current.relationshipName,
                        onFinished: {
                            if !growthQueue.isEmpty {
                                growthQueue.removeFirst()
                            }
                            if growthQueue.isEmpty {
                                showGrowthView = false
                                dismiss()

                            } else {
                                showGrowthView = false
                                
                                Task {
                                    try? await Task.sleep(
                                        for: .milliseconds(300)
                                    )

                                    showGrowthView = true
                                }
                            }
                        }
                    )
                    .id(current.id)
                }
            }
        }
    }

    // MARK: - Save
    private func save() {

        guard let results = viewModel.saveMoment() else {
            return
        }
        let grown = results.filter {
            $0.newStage > $0.oldStage
        }
        guard !grown.isEmpty else {
            dismiss()
            return
        }

        growthQueue = grown.compactMap { result in
            let images = viewModel.growthImages(
                plantName: result.plantName,
                oldStage: result.oldStage,
                newStage: result.newStage
            )
            guard let oldImage = images.0,
                  let newImage = images.1
            else { return nil }

            return GrowthItem(
                oldImage: oldImage,
                newImage: newImage,
                relationshipName: result.relationshipName
            )
        }

        if growthQueue.isEmpty {
            dismiss()
        } else {
            showGrowthView = true
        }
    }
}

#Preview {
    let relationship = Relationship(
        name: "Anna Haro",
        phoneNumber: "0170123456",
        birthDate: .now,
        plant: Plant(type: "cosmos"),
        careRhythm: CareRhythm(interval: 7)
    )
    let vm = MomentViewModel(
        relationship: relationship
    )
    vm.notes = "Wir waren heute zusammen spazieren."
    return MomentView(
        viewModel: vm
    )
}
