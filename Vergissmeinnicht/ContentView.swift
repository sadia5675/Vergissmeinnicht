//
//  ContentView.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 21.05.26.
//

import SwiftUI
import CoreData

/// Wurzelansicht der Anwendung
/// 
/// Sorgt beim Start für die einmalige Befüllung des Bildkatalogs und der vordefinierten Interaktionstypen
struct ContentView: View {
    
    // MARK: - Properties
    
    private let momentService = MomentService.shared
    private let imageService = ImageService.shared
    
    // MARK: - Body
    
    var body: some View {
        GardenView()
            .onAppear {
                imageService.seedIfNeeded()
                momentService.seedInteractionTypesIfNeeded()
            }
    }
}

#Preview {
    GardenView()
}
