//
//  CustomReminderView.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 25.05.26.
//

import SwiftUI

struct CustomReminderView: View {
    @StateObject var viewModel: CustomReminderViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Erinnerungstitel") {
                    TextField("z.B. 'Omas Geburtstag'", text: $viewModel.label)
                }
                
                Section("Wann erinnern?") {
                    DatePicker(
                        "Datum und Zeit",
                        selection: $viewModel.date,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                }
                
                if viewModel.isEditing {
                    Section("Status") {
                        Toggle("Aktiviert", isOn: $viewModel.isActive)
                    }
                }
                
                Section {
                    Button(action: {
                        viewModel.save()
                        dismiss()
                    }) {
                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        } else {
                            Text(viewModel.isEditing ? "Speichern" : "Erinnerung hinzufügen")
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.label.isEmpty || viewModel.isLoading)
                }
                
                // Löschen Button (nur im Edit-Mode)
                if viewModel.isEditing {
                    Section {
                        Button(action: {
                            viewModel.delete()
                            dismiss()
                        }) {
                            Text("Erinnerung löschen")
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle(viewModel.isEditing ? "Erinnerung bearbeiten" : "Neue Erinnerung")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
