//
//  VergissmeinnichtApp.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 21.05.26.
//

import SwiftUI
import CoreData

@main
struct VergissmeinnichtApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
