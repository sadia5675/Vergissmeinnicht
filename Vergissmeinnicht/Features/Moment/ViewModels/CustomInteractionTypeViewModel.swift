//
//  CustomInteractionTypeViewModel.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 26.05.26.
//

import Combine
import Foundation

/// ViewModel für das Erstellen einer benutzerdefinierten Interaktionsart mit passendem Symbol und individueller Bezeichnung
@MainActor
class CustomInteractionTypeViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var selectedSymbol: String = "star.fill"
    @Published var customTypeName: String = ""
    @Published var searchText: String = ""

    // MARK: - Dependencies

    private let momentService = MomentService.shared

    // MARK: - Available Symbole

    /// Alle zur Auswahl stehenden SF Symbols
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

    /// Ordnet Suchbegriffen passende Symbole zu, damit Nutzer:innen auch über deutsche begriffe statt Symbolnamen suchen können
    let searchMappings: [String: [String]] = [

        // Reisen
        "reise": ["airplane", "ferry", "tram", "bus", "car.fill"],
        "urlaub": ["airplane", "beach.umbrella", "mountain.2"],
        "flug": ["airplane"],
        "auto": ["car.fill"],
        "bus": ["bus"],
        "bahn": ["tram"],
        "schiff": ["ferry"],
        "fahrrad": ["bicycle"],

        // Freizeit
        "kino": ["movieclapper", "film"],
        "film": ["movieclapper", "film"],
        "serie": ["film"],
        "theater": ["theatermasks"],
        "spiel": ["gamecontroller"],
        "zocken": ["gamecontroller"],

        // Bücher & Lernen
        "buch": ["book"],
        "lesen": ["book"],
        "lernen": ["book"],

        // Kunst & Kreativität
        "kunst": ["paintpalette", "paintbrush"],
        "malen": ["paintbrush", "paintpalette"],
        "zeichnen": ["paintbrush"],
        "kreativ": ["paintpalette"],

        // Musik
        "musik": ["music.note", "headphones", "guitars"],
        "hören": ["headphones"],
        "gitarre": ["guitars"],
        "konzert": ["music.note"],

        // Sport
        "sport": [
            "figure.run",
            "figure.walk",
            "figure.hiking",
            "sportscourt",
            "soccerball",
            "basketball",
            "tennis.racket",
            "skateboard"
        ],
        "laufen": ["figure.run"],
        "spazieren": ["figure.walk"],
        "wandern": ["figure.hiking"],
        "fußball": ["soccerball"],
        "fussball": ["soccerball"],
        "basketball": ["basketball"],
        "tennis": ["tennis.racket"],
        "skaten": ["skateboard"],

        // Essen & Trinken
        "essen": ["fork.knife"],
        "restaurant": ["fork.knife"],
        "kaffee": ["cup.and.saucer"],
        "cafe": ["cup.and.saucer"],
        "trinken": ["wineglass"],
        "wein": ["wineglass"],

        // Natur
        "natur": ["tree", "leaf", "mountain.2"],
        "baum": ["tree"],
        "pflanze": ["leaf"],
        "sonne": ["sun.max"],
        "wolke": ["cloud"],
        "nacht": ["moon.stars"],
        "strand": ["beach.umbrella"],
        "camping": ["tent"],

        // Geburtstag & Feiern
        "geburtstag": ["birthday.cake"],
        "feier": ["birthday.cake", "sparkles"],
        "party": ["sparkles"],

        // Kommunikation
        "brief": ["envelope"],
        "nachricht": ["envelope"],
        "kontakt": ["envelope"],

        // Beziehung
        "liebe": ["heart"],
        "freundschaft": ["heart"],
        "herz": ["heart"],

        // Geschenke
        "geschenk": ["gift"],
        "überraschung": ["gift"],

        // Einkaufen
        "einkaufen": ["cart"],
        "shopping": ["cart"],

        // Sonstiges
        "stern": ["star"],
        "wichtig": ["star"],
        "erinnerung": ["bell"],
        "glocke": ["bell"],
        "zauber": ["sparkles"],
        "roller": ["scooter"],
        "moped": ["moped"]
    ]

    // MARK: - Search

    /// Symbole, die zum aktuellen Suchtext passen
    /// 
    /// Gibt es eine direkte Zuordnung in searchMappings? Andernfalls wird nach Symbolnamen gefiltert
    var filteredSymbols: [String] {
        if searchText.isEmpty {
            return availableSymbols
        }
        let search = searchText.lowercased()
        if let mapped = searchMappings[search] {
            return mapped
        }
        return availableSymbols.filter {
            $0.localizedCaseInsensitiveContains(searchText)
        }
    }

    // MARK: - Save

    /// Erstellt eine neue benutzerdefinierte Interaktionsart aus dem eingegebenen Namen und dem gewählten Symbol
    func save() -> InteractionType? {
        guard !customTypeName.isEmpty else {
            return nil
        }
        let newType = InteractionType(
            id: UUID(),
            name: customTypeName,
            sfSymbol: selectedSymbol
        )
        momentService.saveInteractionType(newType)
        return newType
    }
}
