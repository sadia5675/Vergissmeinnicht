//
//  CustomReminderCard.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 26.05.26.
//

import SwiftUI

struct CustomReminderCard: View {
    let reminder: CustomReminder
    let isEditing: Bool
    let onToggle: (Bool) -> Void
    let onDelete: () -> Void
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Edit Modus: Delete Button (links, rot)
            if isEditing {
                Button(action: { onDelete() }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                        .font(.title2)
                }
            }
            
            // Info (klickbar zum Editieren)
            Button(action: { onTap() }) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(reminder.label)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .strikethrough(!reminder.isActive)
                        .opacity(reminder.isActive ? 1 : 0.5)
                        .foregroundColor(.black)
                    
                    Text(reminder.date.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // Toggle NUR im Normal-Modus
            if !isEditing {
                Toggle("", isOn: Binding(
                    get: { reminder.isActive },
                    set: { onToggle($0) }
                ))
                .frame(width: 50)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
        .background(Color.orange.opacity(0.1))
        .cornerRadius(8)
    }
}
