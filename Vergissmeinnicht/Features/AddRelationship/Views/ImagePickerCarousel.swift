//
//  ImagePickerCarousel.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 10.06.26.
//

import SwiftUI

struct ImagePickerCarousel: View {
    let items: [(name: String, displayName: String)]
    let selectedName: String?
    let onSelect: (String?) -> Void
    let allowNone: Bool
    let noneLabel: String
    var previewStage: Int? = nil
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                
                // "Keiner" Option
                if allowNone {
                    Button(action: { onSelect(nil) }) {
                        VStack(spacing: 4) {
                            Image(systemName: "xmark.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.gray)
                            Text(noneLabel)
                                .font(.caption)
                        }
                        .padding(8)
                        .background(selectedName == nil ?
                            Color.green.opacity(0.3) : Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                    .foregroundColor(.black)
                }
                
                // Alle Items
                ForEach(items, id: \.name) { item in
                    Button(action: { onSelect(item.name) }) {
                        VStack(spacing: 4) {
                            
                            // Pflanze: name + stage, sonst direkt name
                            let imageName = previewStage != nil ? "\(item.name)_\(previewStage!)" : item.name
                            
                            if let image = UIImage(named: imageName) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                            } else {
                                Image(systemName: "questionmark.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.gray)
                            }
                            Text(item.displayName)
                                .font(.caption)
                        }
                        .padding(8)
                        .background(selectedName == item.name ?
                            Color.green.opacity(0.3) : Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                    .foregroundColor(.black)
                }
            }
            .padding(.vertical, 4)
        }
    }
}
