//
//  BirthdayCard.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 28.06.26.
//

import SwiftUI

/// Zeigen und Bearbeiten von den Geburtstag einer Beziehung
struct BirthdaySection: View {
    
    // MARK: - Properties
    
    @Binding var birthday: Date?

    let isEditing: Bool
    
    private var hasBirthday: Bool {
        birthday != nil
    }
    
    // MARK: - Body
    
    var body: some View {
        if isEditing || hasBirthday {
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    Label(
                        "Geburtstag",
                        systemImage: "gift"
                    )
                    .font(.headline.weight(.bold))
                    .foregroundStyle(Color("PrimaryDark"))
                   
                    Spacer()

                    if isEditing {
                        Toggle(
                            "",
                            isOn: Binding(
                                get: {
                                    birthday != nil
                                },
                                set: { enabled in
                                    if enabled {
                                        if birthday == nil {
                                            birthday = Date()
                                        }
                                    } else {
                                        birthday = nil
                                    }
                                }
                            )
                        )
                        .labelsHidden()
                        .tint(Color("PrimaryDark"))

                    } else {
                        if let birthday {
                            Text(
                                birthday.formatted(
                                    .dateTime
                                        .day()
                                        .month(.wide)
                                )
                            )
                            .fontWeight(.semibold)
                        }
                    }
                }

                if isEditing {
                    Divider()
                   
                    if birthday != nil {
                        DateTimeCard(
                            date: Binding(
                                get: { birthday ?? Date() },
                                set: { birthday = $0 }
                            )
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
}
#Preview("Detail") {
    BirthdaySection(
        birthday: .constant(.now),
        isEditing: false
    )
    .padding()
    .background(Color("Background"))
}

#Preview("Kein Geburtstag") {
    BirthdaySection(
        birthday: .constant(nil),
        isEditing: false
    )
    .padding()
    .background(Color("Background"))
}
