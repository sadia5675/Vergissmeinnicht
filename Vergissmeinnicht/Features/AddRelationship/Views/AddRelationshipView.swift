//
//  AddRelationshipView.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 22.05.26.
//

import SwiftUI

struct AddRelationshipView: View {
    @StateObject var viewModel = AddRelationshipViewModel()
    @Environment(\.dismiss) var dismiss
    @State var showAddCustomReminder = false
    
    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Kontakt-Auswahl
                Section("Person") {
                    Picker("Modus", selection: $viewModel.useContact) {
                        Text("Manuell eingeben").tag(false)
                        Text("Kontakt auswählen").tag(true)
                    }
                    .pickerStyle(.segmented)
                    
                    if viewModel.useContact {
                        // KONTAKT MODUS
                        Button(action: { viewModel.showContactPicker = true }) {
                            HStack {
                                Image(systemName: "person.crop.circle")
                                Text(viewModel.personName.isEmpty ? "Kontakt auswählen" : viewModel.personName)
                                Spacer()
                            }
                        }
                        
                        if !viewModel.phoneNumber.isEmpty {
                            HStack {
                                Image(systemName: "phone")
                                Text(viewModel.phoneNumber)
                                    .foregroundColor(.gray)
                            }
                        }
                    } else {
                        // MANUELL MODUS
                        TextField("Name", text: $viewModel.personName)
                        TextField("Telefonnummer", text: $viewModel.phoneNumber)
                            .keyboardType(.phonePad)
                    }
                }
                
                if let error = viewModel.errorMessage {

                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                ContactPicker(isPresented: $viewModel.showContactPicker) { name, phone in
                    viewModel.personName = name
                    viewModel.phoneNumber = phone ?? ""
                }
                .frame(width: 0, height: 0)
                // MARK: - Pflanze (PFLICHT)
                Section("Pflanze auswählen") {
                    ImagePickerCarousel(
                        items: viewModel.availablePlants,
                        selectedName: viewModel.selectedPlantType,
                        onSelect: { name in
                            if let name { viewModel.selectedPlantType = name }
                        },
                        allowNone: false,
                        noneLabel: "",
                        previewStage: 3 
                    )
                }

                // MARK: - Pot (optional)
                Section("Topf auswählen") {
                    ImagePickerCarousel(
                        items: viewModel.availablePots,
                        selectedName: viewModel.selectedPot,
                        onSelect: { viewModel.selectedPot = $0 },
                        allowNone: true,
                        noneLabel: "Kein Topf"
                    )
                }

                // MARK: - Hintergrund (optional)
                Section("Hintergrund auswählen") {
                    ImagePickerCarousel(
                        items: viewModel.availableBackgrounds,
                        selectedName: viewModel.selectedBackground,
                        onSelect: { viewModel.selectedBackground = $0 },
                        allowNone: true,
                        noneLabel: "Keiner"
                    )
                }
                // MARK: - Care Rhythm
                Section("Wie oft Kontakt?") {
                    Picker("Interval", selection: $viewModel.selectedInterval) {
                        Text("Alle 3 Tage").tag(3)
                        Text("Wöchentlich (7 Tage)").tag(7)
                        Text("Alle 2 Wochen (14 Tage)").tag(14)
                        Text("Monatlich (30 Tage)").tag(30)
                    }
                    Stepper(
                            "\(viewModel.selectedInterval) Tage",
                            value: $viewModel.selectedInterval,
                            in: 1...365
                        )
                    
                    Text("Nächster Kontakt: in \(viewModel.selectedInterval) Tagen")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                // MARK: - Birthday
                Section("Geburtstag") {
                    Toggle("Geburtstag hinzufügen", isOn: $viewModel.showBirthday)
                    
                    if viewModel.showBirthday {
                        DatePicker(
                            "Datum",
                            selection: Binding(
                                get: { viewModel.birthDate ?? Date() },
                                set: { viewModel.birthDate = $0 }
                            ),
                            displayedComponents: .date
                        )
                    }
                }
                // MARK: - Erinnerung
                Section("Zusätzliche Erinnerungen") {

                    Button {
                        showAddCustomReminder = true
                    } label: {
                        Label(
                            "Erinnerung hinzufügen",
                            systemImage: "plus.circle"
                        )
                    }

                    if !viewModel.customReminders.isEmpty {

                        ForEach(viewModel.customReminders) { reminder in

                            VStack(alignment: .leading) {

                                Text(reminder.label)
                                    .fontWeight(.medium)

                                Text(
                                    reminder.date.formatted(
                                        date: .abbreviated,
                                        time: .omitted
                                    )
                                )
                                .font(.caption)
                                .foregroundColor(.gray)
                            }
                        }
                    }
                }
                
                // MARK: - Save Button
                Section {
                    Button(action: save) {
                        if viewModel.isLoading {
                            ProgressView()
                        } else {
                            Text("Freundschaft pflanzen")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(!viewModel.canSave || viewModel.isLoading)
                }
            }
            .navigationTitle("Neue Beziehung")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Abbrechen") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showAddCustomReminder) {

            CustomReminderView(
                viewModel: CustomReminderViewModel(
                    onSave: { reminder in

                        viewModel.customReminders.append(
                            reminder
                        )
                    }
                )
            )
        }
    }
    
    private func save() {
        if viewModel.saveRelationship() {
            dismiss()
        }
    }
}

#Preview {
    AddRelationshipView()
}
