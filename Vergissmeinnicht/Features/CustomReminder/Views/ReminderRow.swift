//
//  ReminderRow.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 28.06.26.
//

import SwiftUI

/// Einzelne Zeile einer Erinnerung, optional antippbar zum Bearbeiten
struct ReminderRow: View {

    // MARK: - Properties

    let reminder: CustomReminder
    var action: (() -> Void)? = nil

    // MARK: - Body

    var body: some View {

        Group {
            if let action {
                Button(action: action) {
                    rowContent
                }
                .buttonStyle(.plain)

            } else {
                rowContent
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color("Surface"))
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color("Border"), lineWidth: 2)
        }
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    // MARK: - Row Content

    private var rowContent: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(reminder.label)
                .font(.headline.weight(.semibold))
                .foregroundStyle(Color("PrimaryDark"))

            Text(
                reminder.date.formatted(
                    .dateTime.day().month(.wide).year().hour().minute()
                )
            )
            .foregroundStyle(Color("Primary"))
        }
    }
}
