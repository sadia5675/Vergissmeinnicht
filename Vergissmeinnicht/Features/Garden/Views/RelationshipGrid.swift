//
//  RelationshipGrid.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 28.06.26.
//

import SwiftUI

/// Zweispaltiges Raster aller Beziehungen als Pflanzenkarten, führt bei Auswahl zur jeweiligen Detailansicht
struct RelationshipGrid: View {

    // MARK: - Properties

    let relationships: [Relationship]

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    // MARK: - Body

    var body: some View {

        LazyVGrid(
            columns: columns,
            spacing: 18
        ) {
            ForEach(relationships) { relationship in
                NavigationLink {
                    DetailView(
                        viewModel: DetailViewModel(
                            relationship: relationship
                        )
                    )
                    
                } label: {
                    PlantCard(
                        relationship: relationship
                    )
                }
            }
        }
    }
}
