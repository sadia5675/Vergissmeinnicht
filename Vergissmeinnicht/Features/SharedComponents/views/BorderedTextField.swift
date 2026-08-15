//
//  BorderedTextField.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 02.07.26.
//

import SwiftUI

/// Umrandetes Textfeld mit optionalem vorangestelltem Icon
struct BorderedTextField: View {

    // MARK: - Properties
    
    var icon: String? = nil
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    // MARK: - Body
    
    var body: some View {
        HStack(spacing: 12) {
            if let icon {
                Image(systemName: icon)
                    .foregroundStyle(Color("Primary"))
            }
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
        }
        .padding()
        .background(Color("Surface"))
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color("Border"), lineWidth: 2)
        }
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

#Preview {

    VStack(spacing: 16) {
        BorderedTextField(
            placeholder: "Erinnerungstitel...",
            text: .constant("")
        )
        BorderedTextField(
            icon: "magnifyingglass",
            placeholder: "Suche z.B. Kino oder Sport",
            text: .constant("")
        )
    }
    .padding()
    .background(Color("Background"))
}
