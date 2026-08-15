//
//  ImageCatalogEntry.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 05.07.26.
//

import Foundation

/// Ein Katalogeintrag für ein Bild-Asset (Pflanze, Topf oder Hintergrund) mit internem Dateinamen und Anzeigenamen
struct ImageCatalogEntry: Identifiable {
    let id: UUID
    let name: String
    let displayName: String
}
