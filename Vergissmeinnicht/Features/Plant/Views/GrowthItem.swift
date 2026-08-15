//
//  GrowthItem.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 10.07.26.
//

import UIKit

/// Datenstruktur für eine Wachstums-Animation: enhält das alte und neue Pflanzenbild sowie den Namen der zugehörigen Beziehung
struct GrowthItem: Identifiable {

    // MARK: - Properties

    let id = UUID()
    let oldImage: UIImage
    let newImage: UIImage
    let relationshipName: String
}
