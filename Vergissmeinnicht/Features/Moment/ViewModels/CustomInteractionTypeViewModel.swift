//
//  CustomInteractionTypeViewModel.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 26.05.26.
//

import Combine
import Foundation

@MainActor
class CustomInteractionTypeViewModel: ObservableObject {
    @Published var selectedSymbol: String = "star.fill"
    @Published var customTypeName: String = ""
    @Published var searchText: String = ""
    
    private let momentService =
        MomentService.shared
    
    // Verfügbare SF Symbols
    let availableSymbols: [String] = [
        "airplane", "car.fill", "bus", "tram", "bicycle", "ferry",
        "gamecontroller", "book", "paintpalette", "music.note", "paintbrush",
        "movieclapper", "film", "headphones", "guitars",
        "figure.run", "figure.walk", "figure.hiking", "sportscourt",
        "tennis.racket", "soccerball", "basketball",
        "fork.knife", "cup.and.saucer", "wineglass", "birthday.cake",
        "tree", "leaf", "sun.max", "cloud", "moon.stars",
        "mountain.2", "beach.umbrella", "tent",
        "skateboard", "scooter", "moped", "sparkles", "theatermasks",
        "envelope", "cart", "gift", "heart", "star", "bell"
    ]
    
    var filteredSymbols: [String] {
        if searchText.isEmpty {
            return availableSymbols
        }
        return availableSymbols.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }
    
    func save() -> InteractionType? {
        guard !customTypeName.isEmpty else { return nil }
        
        let newType = InteractionType(
            id: UUID(),
            name: customTypeName,
            sfSymbol: selectedSymbol,
            isCustom: true
        )
        
        momentService.saveInteractionType(newType)
        
        print("Custom Type erstellt: \(newType.name)")
        return newType
    }
}
