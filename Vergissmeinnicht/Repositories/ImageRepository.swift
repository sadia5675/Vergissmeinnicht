//
//  ImageRepository.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 09.06.26.
//

import CoreData
import Foundation

@MainActor
class ImageRepository {
    
    private let container = PersistenceController.shared.container
    
    // MARK: - LOAD
    
    func loadImages(type: String) -> [(name: String, displayName: String)] {
        let context = container.viewContext
        
        let request = NSFetchRequest<ImageEntity>(
            entityName: "ImageEntity"
        )
        request.predicate = NSPredicate(
            format: "type == %@", type
        )
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \ImageEntity.name, ascending: true)
        ]
        
        do {
            let entities = try context.fetch(request)
            return entities.map {
                (name: $0.name ?? "", displayName: $0.displayName ?? "")
            }
        } catch {
            print("❌ ImageRepository load error: \(error)")
            return []
        }
    }
    
    // MARK: - SEEDS
    
    func needsSeeding() -> Bool {
        let context = container.viewContext
        let request = NSFetchRequest<ImageEntity>(
            entityName: "ImageEntity"
        )
        let count = (try? context.count(for: request)) ?? 0
        return count == 0
    }
    
    func seedImage(type: String, name: String, displayName: String) {
        let context = container.viewContext
        let entity = ImageEntity(context: context)
        entity.id = UUID()
        entity.type = type
        entity.name = name
        entity.displayName = displayName
        save(context)
    }
    
    private func save(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("❌ ImageRepository save error: \(error)")
        }
    }
}
