//
//  DetailView.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 22.05.26.
//

import SwiftUI
import UserNotifications

/// Detailansicht einer Beziehung mit Anzeige und Bearbeitung aller Informationen, Momente-Timeline und situationsabhängigem Hinweis
struct DetailView: View {

    // MARK: - Properties

    @StateObject var viewModel: DetailViewModel
    @StateObject private var hintViewModel = HintViewModel()
    
    @Environment(\.dismiss) private var dismiss

    @State private var showMomentView = false
    @State private var isEditing = false
    @State private var showAddCustomReminder = false
    @State private var editingReminder: CustomReminder?
    @State private var showPlantCustomization = false
    @State private var editPot: String?
    @State private var editBackground: String?
    @State private var editName = ""
    @State private var editPhoneNumber = ""
    @State private var editInterval = 0
    @State private var editBirthDate: Date?

    // MARK: - Computed Properties

    private var previewRelationship: Relationship {
        var preview = viewModel.relationship

        if isEditing {
            preview.name = editName
            preview.plant.pot = editPot
            preview.plant.background = editBackground
        }
        return preview
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 18) {

                    // MARK: - Header with Plant

                    PlantCard(relationship: previewRelationship, size: .large, showName: false)
                        .padding(.horizontal)

                    // MARK: - Edit Plant

                    if isEditing {
                        SecondaryButton(
                            title: "Pflanze bearbeiten",
                            selected: true
                        ) {
                            showPlantCustomization = true
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        .sheet(isPresented: $showPlantCustomization) {
                            NavigationStack {
                                PlantCustomizationView(
                                    selectedPlant: previewRelationship.plant.type,
                                    selectedPot: editPot,
                                    selectedBackground: editBackground,
                                    canChangePlant: false,
                                    availablePlants: viewModel.availablePlants,
                                    availablePots: viewModel.availablePots,
                                    availableBackgrounds: viewModel.availableBackgrounds
                                ) { plant, pot, background in
                                    editPot = pot
                                    editBackground = background

                                    var updated = viewModel.relationship
                                    updated.plant.type = plant
                                    updated.plant.pot = pot
                                    updated.plant.background = background

                                    viewModel.relationship = updated
                                }
                            }
                            .presentationBackground(Color("Background"))
                        }
                    }

                    // MARK: - Hint

                    if !viewModel.relationship.isResting, let hint = hintViewModel.detailHint {
                        HintView(
                            hint: hint,
                            onDismiss: {
                                hintViewModel.dismissDetailHint(
                                    for: viewModel.relationship
                                )
                            }
                        )
                        .padding(.horizontal)
                    }

                    // MARK: - Editable Info

                    InfoCard(
                        relationship: viewModel.relationship,
                        isEditing: isEditing,
                        editName: $editName,
                        editPhone: $editPhoneNumber,
                        editInterval: $editInterval
                    )
                    .padding(.horizontal)

                    // MARK: - CareRhythm

                    CareRhythmSection(
                        interval: Binding(
                            get: {
                                isEditing
                                ? editInterval
                                : viewModel.relationship.careRhythm.interval
                            },
                            set: {
                                editInterval = $0
                            }
                        ),
                        isEditing: isEditing
                    )
                    .padding(.horizontal)

                    // MARK: - Birthday

                    BirthdaySection(
                        birthday: Binding(
                            get: {
                                isEditing
                                ? editBirthDate
                                : viewModel.relationship.birthDate
                            },
                            set: {
                                editBirthDate = $0
                            }
                        ),
                        isEditing: isEditing
                    )
                    .padding(.horizontal)

                    // MARK: - Reminders

                    if !viewModel.relationship.isResting {

                        ReminderSection(
                            title: "Erinnerungen",
                            reminders: viewModel.relationship.customReminders,
                            isEditing: isEditing,
                            onAdd: {
                                showAddCustomReminder = true
                            },
                            onTap: { reminder in
                                editingReminder = reminder
                            }
                        )
                        .padding(.horizontal)

                        // New Reminders
                        .sheet(isPresented: $showAddCustomReminder) {
                            CustomReminderView(
                                viewModel: CustomReminderViewModel(
                                    relationship: viewModel.relationship
                                )
                            )
                        }

                        .onChange(of: showAddCustomReminder) { _, newValue in
                            if !newValue {
                                viewModel.loadRelationship()
                            }
                        }
                        
                        // Edit Reminders
                        .sheet(item: $editingReminder) { reminder in
                            CustomReminderView(
                                viewModel: CustomReminderViewModel(
                                    relationship: viewModel.relationship,
                                    editing: reminder
                                )
                            )
                        }

                        .onChange(of: editingReminder) { _, newValue in
                            if newValue == nil {
                                viewModel.loadRelationship()
                            }
                        }
                    }

                    // MARK: - Action Buttons

                    if !viewModel.relationship.isResting, !isEditing {
                        PrimaryButton(
                            title: "Moment hinzufügen",
                            selected: true
                        ) {
                            showMomentView = true
                        }
                        .padding(.horizontal)
                        .sheet(isPresented: $showMomentView) {
                            MomentView(
                                viewModel: MomentViewModel(
                                    relationship: viewModel.relationship
                                )
                            )
                        }
                        .onChange(of: showMomentView) { _, newValue in
                            if !newValue {
                                viewModel.loadRelationship()
                                viewModel.loadMoments()

                                hintViewModel.loadHint(
                                    for: viewModel.relationship
                                )
                            }
                        }
                    }

                    // MARK: - Timeline

                    VStack(alignment: .leading, spacing: 18) {
                        Text("Momente")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(Color("PrimaryDark"))

                        if viewModel.moments.isEmpty {
                            EmptyStateView(
                                title: "Noch keine Momente",
                                subtitle: "",
                                icon: "photo.on.rectangle",
                                size: .compact
                            )

                        } else {
                            ScrollView {
                                LazyVStack(spacing: 0) {
                                    ForEach(
                                        Array(viewModel.moments.enumerated()),
                                        id: \.element.id
                                    ) { index, moment in
                                        
                                        TimelineCard(
                                            moment: moment,
                                            isLast: index == viewModel.moments.count - 1,
                                            photo: viewModel.photoFor(moment),
                                            participants: viewModel.participants(for: moment)
                                        )
                                    }
                                }
                            }
                            .frame(maxHeight: 350)
                        }
                    }
                    .padding(20)
                    .background(Color.white)
                    .overlay {
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color("Border"), lineWidth: 1.5)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding(.horizontal)

                    if viewModel.relationship.isResting {
                        SecondaryButton(
                            title: "Zurück in den Garten",
                            selected: true
                        ) {
                            viewModel.toggleResting()
                        }
                        .padding(.horizontal)

                    } else if isEditing {
                        SecondaryButton(
                            title: "Zur Ruhe legen",
                            selected: false
                        ) {

                            viewModel.toggleResting()
                        }
                        .padding(.horizontal)
                    }
                }
                .navigationTitle("Details")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            if isEditing {
                                isEditing = false

                            } else {
                                dismiss()
                            }

                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "chevron.left")
                                Text("Zurück")
                            }
                            .font(.headline)
                        }
                    }

                    ToolbarItem(placement: .topBarTrailing) {
                        if !viewModel.relationship.isResting {
                            if isEditing {
                                Button {
                                    viewModel.saveChanges(
                                        pot: editPot,
                                        background: editBackground,
                                        name: editName,
                                        phoneNumber: editPhoneNumber,
                                        interval: editInterval,
                                        birthDate: editBirthDate
                                    )
                                    isEditing = false

                                } label: {
                                    Text("Speichern")
                                        .fontWeight(.bold)
                                }
                                .disabled(editName.isEmpty)

                            } else {
                                Button {
                                    startEditing()
                                    isEditing = true

                                } label: {
                                    Text("Bearbeiten")
                                        .fontWeight(.semibold)
                                }
                            }
                        }
                    }
                }
                .navigationBarBackButtonHidden(true)
            }
        }
        .onAppear {

            hintViewModel.loadHint(
                for: viewModel.relationship
            )
        }
    }

    // MARK: - Helper Function

    func startEditing() {
        editPot = viewModel.relationship.plant.pot
        editBackground = viewModel.relationship.plant.background
        editName = viewModel.relationship.name
        editPhoneNumber = viewModel.relationship.phoneNumber
        editInterval = viewModel.relationship.careRhythm.interval
        editBirthDate = viewModel.relationship.birthDate
    }
}
#Preview {
    NavigationStack {
        DetailView(
            viewModel: DetailViewModel(
                relationship: Relationship(
                    name: "Anna Haro",
                    phoneNumber: "0170123456",
                    birthDate: .now,
                    plant: Plant(
                        type: "cosmos",
                        pot: "pot",
                        background: "bg_watercolor"
                    ),
                    careRhythm: CareRhythm(interval: 7)
                )
            )
        )
    }
}
