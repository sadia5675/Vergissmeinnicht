//
//  CareRhythmSection.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 28.06.26.
//

import SwiftUI

/// Zeigen und Bearbeiten eines Pflegerhythmus einer Beziehung
struct CareRhythmSection: View {
   
    // MARK: - Properties
    
    @Binding var interval: Int

    let isEditing: Bool

    @State private var isEditingCustomInterval = false
    @State private var isCustomInterval = false
    @State private var customInterval = ""
    @FocusState private var isCustomIntervalFocused: Bool

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    private let defaultIntervals = [3, 7, 14, 30]

    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Label(
                    "Pflegeintervall",
                    systemImage: "clock"
                )
                .font(.headline.weight(.bold))
                .foregroundStyle(Color("PrimaryDark"))

                Spacer()

                if !isEditing {
                    Text("alle \(interval) Tage")
                        .fontWeight(.semibold)
                }
            }

            if isEditing {
                Divider()
                
                LazyVGrid(
                    columns: columns,
                    spacing: 12
                ) {
                    ForEach(defaultIntervals, id: \.self) { value in
                        IntervalButton(
                            days: value,
                            selected: !isCustomInterval && interval == value
                        ) {

                            interval = value
                            isCustomInterval = false
                        }
                    }
                }

                // MARK: Rhythm

                if isEditingCustomInterval {
                    HStack {
                        TextField("z.B. 10", text: $customInterval)
                        .keyboardType(.numberPad)
                        .submitLabel(.done)
                        .focused($isCustomIntervalFocused)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Fertig") {
                                    submitCustomInterval()
                                }
                            }
                        }

                        Text("Tage").foregroundStyle(Color("Primary"))
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color("PrimaryDark"))
                    .padding()
                    .frame(height: 52)
                    .background(Color("Surface"))
                    .overlay {
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(
                                Color("Border"),
                                style: StrokeStyle(
                                    lineWidth: 2,
                                    dash: [8]
                                )
                            )
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .onSubmit {
                        submitCustomInterval()
                    }
                    .onAppear {
                        isCustomIntervalFocused = true
                    }

                } else {
                    if isCustomInterval {
                        Button {
                            customInterval = "\(interval)"
                            isEditingCustomInterval = true

                        } label: {
                            Text("\(interval) Tage")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(Color("PrimaryDark"))
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(Color("Secondary"))
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 18)
                                )
                        }
                        .buttonStyle(.plain)

                    } else {
                        DashedButton(
                            title: "Eigener Rhythmus..."
                        ) {

                            customInterval = ""
                            isEditingCustomInterval = true
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .overlay {
            RoundedRectangle(cornerRadius: 24).stroke(Color("Border"), lineWidth: 1.5)
        }
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .onAppear {
            isCustomInterval = !defaultIntervals.contains(interval)
        }
    }

    // MARK: - Submit Helper

    private func submitCustomInterval() {
        if let value = Int(customInterval),
           value > 0 {
            interval = value
            isCustomInterval = true
        }
        isEditingCustomInterval = false
        isCustomIntervalFocused = false
    }
}

#Preview("Bearbeiten") {
    CareRhythmSection(
        interval: .constant(7),
        isEditing: true
    )
    .padding()
    .background(Color("Background"))
}

#Preview("Ansicht") {
    CareRhythmSection(
        interval: .constant(14),
        isEditing: false
    )
    .padding()
    .background(Color("Background"))
}
