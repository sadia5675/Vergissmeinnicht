//
//  RelationshipStatus.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 12.06.26.
//

import SwiftUI
import Foundation

enum RelationshipStatus {

    case blooming
    case needsCare
    case missesYou

    var displayText: String {

        switch self {

        case .blooming:
            return "Blüht"

        case .needsCare:
            return "Braucht Pflege"

        case .missesYou:
            return "Vermisst dich"
        }
        
    }
    
    var color: Color {

        switch self {

           case .blooming:
               return .green

           case .needsCare:
               return .orange

           case .missesYou:
               return .gray
           }
       }
    
    var backgroundColor: Color {

        switch self {

        case .blooming:
            return .green.opacity(0.2)

        case .needsCare:
            return .orange.opacity(0.2)

        case .missesYou:
            return .gray.opacity(0.2)
        }
    }
}
