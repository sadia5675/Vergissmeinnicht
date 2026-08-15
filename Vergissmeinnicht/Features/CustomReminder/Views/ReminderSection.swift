//
//  ReminderSection.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 28.06.26.
//

import SwiftUI

/// Karte mit der Liste aller Erinnerungen einer Beziehung sowie Hinzufügen im Bearbeitungsmodus
struct ReminderSection: View {

    // MARK: - Properties

    let title: String
    let reminders: [CustomReminder]
    let isEditing: Bool

    let onAdd: () -> Void
    let onTap: (CustomReminder) -> Void

    // MARK: - Body

    var body: some View {

        VStack(alignment: .leading, spacing: 18) {

            HStack {
                Text(title)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(Color("PrimaryDark"))

                Spacer()

                if isEditing {
                    Button(action: onAdd) {
                        Image(systemName: "plus")
                            .font(.headline)
                            .foregroundStyle(Color("PrimaryDark"))
                            .frame(width: 38, height: 38)
                            .background(Color("Surface"))
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color("Border"), lineWidth: 2)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }

            if reminders.isEmpty {
                EmptyStateView(
                    title: "Noch keine Erinnerungen",
                    subtitle: "",
                    icon: "calendar.badge.plus",
                    size: .compact
                )

            } else {

                ForEach(reminders) { reminder in
                    
                    ReminderRow(
                        reminder: reminder,
                        action: isEditing ? { onTap(reminder) } : nil
                    )
                }
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
