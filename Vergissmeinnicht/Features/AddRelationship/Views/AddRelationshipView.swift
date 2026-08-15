//
//  AddRelationshipView.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 22.05.26.
//

import SwiftUI

/// Formular zum Anlegen einer neuen Beziehung sowie Kontakt, Pflanze, Erinnerungen und Pflegerhythmus
struct AddRelationshipView: View {

    // MARK: - Properties

    @StateObject var viewModel = AddRelationshipViewModel()
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var showAddCustomReminder = false
    @State private var showPlantCustomization = false
    @State private var editingReminder: CustomReminder?

    // MARK: - Computed Properties

    var previewRelationship: Relationship {
        Relationship(
            name: viewModel.personName.isEmpty
            ? "Neue Beziehung"
            : viewModel.personName,

            phoneNumber: viewModel.phoneNumber,

            plant: Plant(
                type: viewModel.selectedPlantType,
                pot: viewModel.selectedPot,
                background: viewModel.selectedBackground
            ),
            careRhythm: CareRhythm(
                interval: viewModel.selectedInterval
            )
        )
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {

                    // MARK: - Header

                    Text("Füg einen Freund hinzu")
                        .font(.title.bold())
                        .foregroundStyle(Color("PrimaryDark"))

                    Text("""
                    Die App lebt von echten Beziehungen.
                    Mit wem möchtest du verbunden bleiben?
                    """)
                    .foregroundStyle(Color("Primary"))

                    ContactSection(viewModel: viewModel)

                    // MARK: - Plant

                    Text("Wähle eine Pflanze aus")
                        .font(.title.bold())
                        .foregroundStyle(Color("PrimaryDark"))
                    
                    Text("Welche Pflanze passt am besten zu eurer Beziehung?")
                        .foregroundStyle(Color("Primary"))

                    PlantSection(
                        viewModel: viewModel,
                        showCustomization: $showPlantCustomization
                    )
                    .sheet(isPresented: $showPlantCustomization) {

                        NavigationStack {
                            PlantCustomizationView(
                                selectedPlant: viewModel.selectedPlantType,
                                selectedPot: viewModel.selectedPot,
                                selectedBackground: viewModel.selectedBackground,
                                canChangePlant: true,
                                availablePlants: viewModel.availablePlants,
                                availablePots: viewModel.availablePots,
                                availableBackgrounds: viewModel.availableBackgrounds
                            ) { plant, pot, background in

                                viewModel.selectedPlantType = plant
                                viewModel.selectedPot = pot
                                viewModel.selectedBackground = background
                            }
                        }
                        .presentationBackground(Color("Background"))
                    }

                    // MARK: - Reminders

                    Text("Füge Erinnerungen hinzu")
                        .font(.title.bold())
                        .foregroundStyle(Color("PrimaryDark"))

                    Text("""
                    Geburtstage und weitere Erinnerungen
                    helfen dir, Beziehungen zu pflegen.
                    """)
                    .foregroundStyle(Color("Primary"))

                    BirthdaySection(
                        birthday: $viewModel.birthDate,
                        isEditing: true
                    )

                    ReminderSection(
                        title: "Erinnerungen",
                        reminders: viewModel.customReminders,
                        isEditing: true,
                        onAdd: {
                            showAddCustomReminder = true
                        },
                        onTap: { reminder in
                            editingReminder = reminder
                        }
                    )
                    .sheet(isPresented: $showAddCustomReminder) {
                        CustomReminderView(
                            viewModel: CustomReminderViewModel(
                                onSave: { reminder in

                                    viewModel.customReminders.append(reminder)
                                }
                            )
                        )
                        .presentationBackground(Color("Background"))
                    }
                    .sheet(item: $editingReminder) { reminder in
                        CustomReminderView(
                            viewModel: CustomReminderViewModel(
                                editing: reminder,
                                onSave: { updatedReminder in

                                    if let index = viewModel.customReminders.firstIndex(where: {
                                        $0.id == updatedReminder.id
                                    }) {
                                        viewModel.customReminders[index] = updatedReminder
                                    }
                                }
                            )
                        )
                    }

                    // MARK: - Rhythm

                    Text("Wie oft möchtest du diese Beziehung pflegen?")
                        .font(.title.bold())
                        .foregroundStyle(Color("PrimaryDark"))

                    Text("""
                    Du entscheidest –
                    die App erinnert dich sanft.
                    """)
                    .foregroundStyle(Color("Primary"))

                    CareRhythmSection(
                        interval: $viewModel.selectedInterval,
                        isEditing: true
                    )

                    PrimaryButton(
                        title: viewModel.isLoading
                            ? "Speichern..."
                            : "Freundschaft pflanzen",
                        selected: true
                    ) {
                        save()
                    }
                    .disabled(viewModel.isLoading)
                }
                .padding()

                ContactPicker(
                    isPresented: $viewModel.showContactPicker
                ) { name, phone, birthday in

                    viewModel.didSelectContact(
                        name: name,
                        phone: phone,
                        birthday: birthday
                    )
                }
                .frame(width: 0, height: 0)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Abbrechen") {
                            dismiss()
                        }
                    }
                }
            }
            .background(Color("Background"))
        }
    }

    // MARK: - Save

    private func save() {
        if viewModel.saveRelationship() {
            dismiss()
        }
    }
}

#Preview {
    AddRelationshipView()
}
