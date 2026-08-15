//
//  NotesSection.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 01.07.26.
//

import SwiftUI

/// Notizfeld mit vorgefertigten Textbaustein Vorschlägen für einen Moment
struct NotesSection: View {

    // MARK: - Properties

    @Binding var notes: String
    @FocusState private var isNotesFocused: Bool

    let templates: [String]

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {

            Text("Notizen")
                .font(.headline.weight(.bold))
                .foregroundStyle(Color("PrimaryDark"))

            // MARK: - Suggestions

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {

                    ForEach(templates, id: \.self) { template in
                        
                        Button {
                            if notes.isEmpty {
                                notes = template

                            } else {
                                notes += "\n" + template
                            }

                        } label: {
                            Text(template)
                                .font(.caption.weight(.medium))
                                .foregroundStyle(Color("PrimaryDark"))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(Color("Surface"))
                                .clipShape(Capsule())
                                .overlay {
                                    Capsule()
                                        .stroke(
                                            Color("Border"),
                                            lineWidth: 1.5
                                        )
                                }
                        }
                    }
                }
            }

            // MARK: - TextEditor

            ZStack(alignment: .topLeading) {

                if notes.isEmpty {
                    Text("Beschreibe euren Moment...")
                        .foregroundStyle(Color("Primary"))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 10)
                }
                TextEditor(text: $notes)
                    .focused($isNotesFocused)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .frame(minHeight: 150)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Fertig") {
                                isNotesFocused = false
                            }
                        }
                    }
            }
            .padding(12)
            .background(Color("Surface"))
            .overlay {

                RoundedRectangle(cornerRadius: 18)
                    .stroke(
                        Color("Border"),
                        lineWidth: 2
                    )
            }
            .clipShape(
                RoundedRectangle(cornerRadius: 18)
            )
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

#Preview {

    NotesSection(
        notes: .constant(""),
        templates: [
            "Schön dich gesehen.",
            "Kaffee getrunken.",
            "Viel gelacht.",
            "Spaziergang.",
            "Geburtstag gefeiert."
        ]
    )
    .padding()
    .background(Color("Background"))
}
