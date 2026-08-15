//
//  ImagePickerGrid.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 27.06.26.
//

import SwiftUI

enum CustomizationGridType {
    case plant
    case pot
    case background
}

/// Rasteransicht zur Auswahl von Pflanzen, Töpfen oder Hintergründe
struct CustomizationGrid: View {

    // MARK: - Properties
    
    let items: [ImageCatalogEntry]
    let selectedName: String?
    let onSelect: (String?) -> Void
    let allowNone: Bool
    let noneLabel: String
    let type: CustomizationGridType

    var previewStage: Int? = nil

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // MARK: - Body

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {

                // Keine Auswahl
                if allowNone {
                    Button {
                        onSelect(nil)
                    } label: {
                        VStack {
                            Image(systemName: "xmark.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 55, height: 55)
                                .foregroundStyle(Color("Primary"))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 130)
                        .background(
                            selectedName == nil
                            ? Color("Secondary")
                            : Color("Surface")
                        )
                        .cornerRadius(18)
                    }
                    .foregroundColor(.black)
                }

                // Alle Bilder
                ForEach(items) { item in
                    Button {
                        onSelect(item.name)

                    } label: {
                        let imageName = previewStage != nil
                            ? "\(item.name)_\(previewStage!)"
                            : item.name
                        ZStack {
                            if let image = UIImage(named: imageName) {
                                if type == .background {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 130)
                                        .clipped()

                                } else {
                                    Color("Surface")
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                }

                            } else {
                                Color("Surface")
                                Image(systemName: "questionmark.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 55, height: 55)
                                    .foregroundStyle(Color("Primary"))
                            }

                        }
                        .frame(height: 130)
                        .background(
                            selectedName == item.name
                            ? Color("Secondary")
                            : Color.clear
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }
}
