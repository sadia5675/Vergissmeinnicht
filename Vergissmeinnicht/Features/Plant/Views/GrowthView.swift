//
//  GrowthView.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 21.06.26.
//

import SwiftUI

/// Zeigt eine zweiphasige Animation, wenn sich die Wachstumsstufe einer Pflanze durch einen neuen Moment erhöht hat
struct GrowthView: View {

    // MARK: - Properties

    let oldImage: UIImage
    let newImage: UIImage
    let relationshipName: String
    let onFinished: () -> Void

    @State private var currentStep = 0
    @State private var showMessage = false
    @State private var showNewPlant = false

    // MARK: - Body

    var body: some View {

        ZStack {
            Color("Background")
                .ignoresSafeArea()

            VStack(spacing: 24) {
                if currentStep == 0 {
                    Spacer()

                    Text("Bei \(relationshipName) hat sich etwas verändert")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(Color("PrimaryDark"))
                        .multilineTextAlignment(.center)

                    HStack {
                        Spacer()

                        PrimaryButton(
                            title: "Weiter",
                            selected: true
                        ) {
                            currentStep = 1
                            DispatchQueue.main.asyncAfter(
                                deadline: .now() + 0.5
                            ) {
                                withAnimation(
                                    .easeInOut(duration: 1.8)
                                ) {
                                    showNewPlant = true
                                }

                                DispatchQueue.main.asyncAfter(
                                    deadline: .now() + 0.9
                                ) {
                                    UINotificationFeedbackGenerator()
                                        .notificationOccurred(.success)
                                }

                                DispatchQueue.main.asyncAfter(
                                    deadline: .now() + 1.8
                                ) {
                                    withAnimation {
                                        showMessage = true
                                    }
                                }
                            }
                        }
                        .frame(width: 200)
                        Spacer()
                    }
                    Spacer()

                } else {
                    Spacer()

                    ZStack {
                        Image(uiImage: oldImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 220)
                            .opacity(showNewPlant ? 0 : 1)
                        
                        Image(uiImage: newImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 220)
                            .opacity(showNewPlant ? 1 : 0)
                            .scaleEffect(
                                showNewPlant ? 1 : 0.8
                            )
                            .offset(
                                y: showNewPlant ? -10 : 0
                            )
                    }

                    if showMessage {
                        Text("Die Beziehung zu \(relationshipName) ist ein kleines Stück gewachsen.")
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(Color("PrimaryDark"))
                            .multilineTextAlignment(.center)
                            .transition(.opacity)
                    }

                    if showMessage {
                        HStack {
                            Spacer()

                            PrimaryButton(
                                title: "Schön",
                                selected: true
                            ) {
                                onFinished()
                            }
                            .frame(width: 200)
                            .transition(.opacity)
                            Spacer()
                        }
                    }
                    Spacer()
                }
            }
            .padding()
        }
    }
}
#Preview {
    GrowthView(
        oldImage: UIImage(systemName: "leaf")!,
        newImage: UIImage(systemName: "leaf.fill")!,
        relationshipName: "Anna",
        onFinished: {}
    )
}
