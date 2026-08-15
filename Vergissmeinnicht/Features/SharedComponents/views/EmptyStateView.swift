//
//  GardenEmptyState.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 29.06.26.
//

import SwiftUI

/// Platzhalteransicht für leere Listen, als große oder kompakte Variante
struct EmptyStateView: View {

    enum Size {
        case large
        case compact
    }

    // MARK: - Properties
    
    let title: String?
    let subtitle: String
    let icon: String
    var size: Size = .large

    // MARK: - Body
    
    var body: some View {
        if size == .compact {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(Color("Primary"))
                Text(title ?? subtitle)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color("PrimaryDark"))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)

        } else {
            VStack(spacing: 20) {
                Image(systemName: icon)
                    .font(.system(size: 55))
                    .foregroundStyle(Color("Primary"))

                if let title {
                    Text(title)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(Color("PrimaryDark"))
                }
                Text(subtitle)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color("Primary"))
                    .padding(.horizontal, 30)
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: 350)
        }
    }
}
