//
//  TextService.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 20.06.26.
//

import Foundation

/// Lädt einmalig alle dynamischen Texte der App aus Texts.json und hält sie zentral im Speicher vor
///
/// Fehlt die Datei oder ist sie fehlerhaft, bricht die App beim Start bewusst mit einem klaren Fehler ab
@MainActor
class TextService {

    static let shared = TextService()
    private(set) var texts: Texts

    private init() {
        texts = Self.loadTexts()
    }

    private static func loadTexts() -> Texts {
        guard let url = Bundle.main.url(
            forResource: "Texts",
            withExtension: "json"
        ) else {
            fatalError("Texts.json fehlt")
        }
        
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(Texts.self, from: data)

        } catch {
            fatalError("Texts.json Fehler: \(error)")
        }
    }
}
