//
//  CustomReminderView.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 25.05.26.
//

import SwiftUI

/// Formular zum Erstellen, Bearbeiten oder Löschen einer benutzerdefinierten Erinnerung
struct CustomReminderView: View {

    // MARK: - Properties

    @StateObject var viewModel: CustomReminderViewModel

    @Environment(\.dismiss) private var dismiss

    // MARK: - Body

    var body: some View {
        NavigationStack {

            VStack(alignment: .leading, spacing: 28) {
                Text("Neue Erinnerung")
                    .font(.title.bold())
                    .foregroundStyle(Color("PrimaryDark"))

                Text("""
                Füge einen besonderen Termin hinzu,
                damit du ihn nicht vergisst.
                """)
                .foregroundStyle(Color("Primary"))

                BorderedTextField(
                    placeholder: "Erinnerungstitel...",
                    text: $viewModel.label
                )

                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
                
                DateTimeCard(date: $viewModel.date, showTime: true)
                
                Spacer()

                SecondaryButton(
                    title: viewModel.isEditing
                        ? "Speichern"
                        : "Erinnerung hinzufügen",
                    selected: true
                ) {
                    if viewModel.saveCustomReminder() {
                        dismiss()
                    }
                }
                .disabled(viewModel.isLoading)

                if viewModel.isEditing && viewModel.canDelete {
                    SecondaryButton(
                        title: "Erinnerung löschen",
                        selected: false
                    ) {
                        viewModel.delete()
                        dismiss()
                    }
                }
            }
            .padding()
            .background(Color("Background"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Abbrechen") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    CustomReminderView(
        viewModel: CustomReminderViewModel()
    )
}
