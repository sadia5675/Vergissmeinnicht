//
//  PhotoSection.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 01.07.26.
//

import SwiftUI
import PhotosUI

/// Karte zur Auswahl und Anzeige eines optionalen Fotos für einen Moment
struct PhotoSection: View {

    // MARK: - Properties

    @Binding var image: UIImage?

    @State private var selectedItem: PhotosPickerItem?

    // MARK: - Body

    var body: some View {

        VStack(alignment: .leading, spacing: 18) {

            Text("Foto")
                .font(.headline.weight(.bold))
                .foregroundStyle(Color("PrimaryDark"))

            PhotosPicker(
                selection: $selectedItem,
                matching: .images
            ) {

                if let image {

                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 180)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 20))

                } else {

                    VStack(spacing: 14) {

                        Image(systemName: "photo.badge.plus")
                            .font(.system(size: 36))
                            .foregroundStyle(Color("Primary"))

                        Text("Foto hinzufügen")
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(Color("PrimaryDark"))

                        Text("Halte euren Moment fest")
                            .font(.caption)
                            .foregroundStyle(Color("Primary"))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 180)
                    .background(Color("Surface"))
                    .overlay {

                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                Color("Border"),
                                style: StrokeStyle(
                                    lineWidth: 2,
                                    dash: [8]
                                )
                            )
                    }
                }
            }
            .buttonStyle(.plain)
            .onChange(of: selectedItem) { _, newItem in

                Task {

                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        image = UIImage(data: data)
                    }
                }
            }

            if image != nil {

                SecondaryButton(
                    title: "Foto entfernen",
                    selected: false
                ) {

                    image = nil
                    selectedItem = nil
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
