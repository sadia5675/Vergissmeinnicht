//
//  HintView.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 23.05.26.
//

import SwiftUI

struct HintView: View {
    let hint: Hint
    //let relationships: [Relationship]
    var onDismiss: () -> Void = {}
    
    @State private var showMessageSheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text(hint.relationshipStatus.displayText)
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            hint.relationshipStatus.backgroundColor
                        )
                        .foregroundColor(
                            hint.relationshipStatus.color
                        )
                        .clipShape(Capsule())
                    
                    
                    Text(hint.displayContent)
                        .font(.headline)
                        .lineLimit(2)
                    
                    
                    if let photoPath =
                        hint.sourceMoment?.photoPath,
                       let image =
                        MomentService.shared.loadPhoto(photoPath) {

                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 120)
                            .clipped()
                            .cornerRadius(8)
                    }
                    
                    if hint.phoneNumber != nil {

                        Button(
                            hint.actionButtonText ?? "Nachricht schreiben"
                        ) {
                            showMessageSheet = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    
                }
                .sheet(
                    isPresented: $showMessageSheet
                ) {

                    MessageComposer(
                        recipients: [
                            hint.phoneNumber ?? ""
                        ],
                        body:
                            hint.prefilledMessage ?? ""
                    )
                }
                
                Spacer()
                
                Button(action: onDismiss) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(hintBackgroundColor())
        .cornerRadius(12)
    }
    
    private func hintBackgroundColor() -> Color {
        switch hint.relationshipStatus {
        case .missesYou:
            return Color.red.opacity(0.1)
        case .needsCare:
            return Color.yellow.opacity(0.1)
        case .blooming:
            return Color.green.opacity(0.1)
        }
    }
}

/*#Preview {
    HintView(
        hint: Hint(
            relationshipStatus: .needsCare,
            displayContent: "Zeit für Anna?",
            prefilledMessage: "Hey Anna!"
        )
    )
}*/
