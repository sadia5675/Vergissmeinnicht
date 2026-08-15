//
//  VergissmeinnichtApp.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 21.05.26.
//

import SwiftUI
import CoreData

/// Einstiegspunkt der Anwendung
/// 
/// Richtet den CoreData-Kontext für die gesamte View-Hierarchie ein
@main
struct VergissmeinnichtApp: App {
    // MARK: - Properties
    
    let persistenceController = PersistenceController.shared

    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
