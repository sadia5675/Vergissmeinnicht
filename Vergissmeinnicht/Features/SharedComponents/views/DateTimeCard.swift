//
//  DateTimeCard.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 02.07.26.
//

import SwiftUI

/// Karte zur Auswahl von Datum und optional Uhrzeit, mit optional begrenzbarem maximalen Datum
struct DateTimeCard: View {
    
    // MARK: - Properties

    @Binding var date: Date
    var showTime: Bool = false
    var maxDate: Date? = nil

    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 18) {
            HStack {
                Text("Datum")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color("PrimaryDark"))
                Spacer()

                if let maxDate {
                    DatePicker(
                        "",
                        selection: $date,
                        in: ...maxDate,
                        displayedComponents: .date
                    )
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    .tint(Color("PrimaryDark"))

                } else {
                    DatePicker(
                        "",
                        selection: $date,
                        displayedComponents: .date
                    )
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    .tint(Color("PrimaryDark"))
                }
            }

            if showTime {
                Divider()

                HStack {
                    Text("Uhrzeit")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color("PrimaryDark"))
                    Spacer()

                    DatePicker(
                        "",
                        selection: $date,
                        displayedComponents: .hourAndMinute
                    )
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    .tint(Color("PrimaryDark"))
                }
            }
        }
        .padding()
        .background(Color("Surface"))
        .overlay {
            RoundedRectangle(cornerRadius: 18).stroke(Color("Border"), lineWidth: 2)
        }
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

#Preview("Nur Datum") {
    DateTimeCard(date: .constant(Date()))
    .padding()
    .background(Color("Background"))
}

#Preview("Datum + Uhrzeit") {
    DateTimeCard(date: .constant(Date()), showTime: true)
    .padding()
    .background(Color("Background"))
}
