//
//  ZoomableImage.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 19.07.26.
//

import SwiftUI

/// Zeigt ein Bild an, das sich per Antippen vergrößert anzeigen lässt
struct ZoomableImage: View {

    let image: UIImage
    let cornerRadius: CGFloat
    let height: CGFloat

    @State private var isZoomed = false

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(height: height)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .onTapGesture {
                isZoomed = true
            }
            .fullScreenCover(isPresented: $isZoomed) {
                ZStack(alignment: .topTrailing) {
                    Color.black.ignoresSafeArea()

                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity
                        )

                    Button {
                        isZoomed = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 32))
                            .foregroundStyle(.white)
                            .padding()
                    }
                }
            }
    }
}
