//
//  RelationshipStatus.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 12.06.26.
//

import SwiftUI
import Foundation

/// Der aktuelle Pflegezustand der Beziehung, ergibt sich aus dem Pflegeintervall und den vergangenen Tagen seit dem letzten Kontakt
enum RelationshipStatus {
    
    /// Die Beziehung wird aktiv gepflegt
    case blooming
    
    /// Das Pflegeintervall wurde überschritten
    case needsCare
    
    /// Das doppelte Pflegeintervall wurde überschritten
    case missesYou

    var displayText: String {
        switch self {
        case .blooming:
            return TextService.shared.texts.status.blooming
        case .needsCare:
            return TextService.shared.texts.status.needsCare
        case .missesYou:
            return TextService.shared.texts.status.missesYou
        }
    }
    
    /// Hintergrundfarbe des Status-Chips
    var chipBackground: Color {
        switch self {
        case .blooming:
            return Color("Secondary")
        case .needsCare:
            return Color("Background")
        case .missesYou:
            return Color("Surface")
        }
    }

    /// Textfarbe des Status-Chips
    var chipForeground: Color {
        switch self {
        case .blooming:
            return Color("PrimaryDark")
        case .needsCare:
            return Color("Primary")
        case .missesYou:
            return .gray
        }
    }
}

