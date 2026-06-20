//
//  ImageService.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 09.06.26.
//

import UIKit
import Foundation

@MainActor
class ImageService {
    
    static let shared = ImageService()
    
    private let repository = ImageRepository()
    
    // MARK: - LOAD
    
    func loadPlants() -> [(name: String, displayName: String)] {
        repository.loadImages(type: "plant")
    }
    
    func loadPots() -> [(name: String, displayName: String)] {
        repository.loadImages(type: "pot")
    }
    
    func loadBackgrounds() -> [(name: String, displayName: String)] {
        repository.loadImages(type: "background")
    }
    
    // MARK: - GET IMAGE
    
    func getPlantImage(name: String, stage: Int) -> UIImage? {
        UIImage(named: "\(name)_\(stage)")
    }
    
    func getPotImage(name: String) -> UIImage? {
        UIImage(named: name)
    }
    
    func getBackgroundImage(name: String) -> UIImage? {
        UIImage(named: name)
    }
    
    // MARK: - SEEDS
    
    func seedIfNeeded() {
        guard repository.needsSeeding() else {
            print("✅ Seeds bereits vorhanden")
            return
        }
        
        print("🌱 Lade Seeds...")
        
        // Pflanzen
        let plants = [
            ("cosmos", "Kosmos"),
            ("pansy", "Stiefmütterchen"),
            ("monstera", "Monstera"),
            ("leaf", "Blatt"),
            ("cactus", "Kaktus")
        ]
        for (name, display) in plants {
            repository.seedImage(type: "plant", name: name, displayName: display)
        }
        
        // Pots
        let pots = [
            ("hat", "Hut"),
            ("pot", "Topf"),
            ("plantPot", "Pflanztopf"),
            ("carton", "Karton"),
            ("teaPot", "Teekanne")
        ]
        for (name, display) in pots {
            repository.seedImage(type: "pot", name: name, displayName: display)
        }
        
        // Backgrounds
        let backgrounds = [
            ("bg_watercolor",   "Wasserfarben"),
            ("bg_wallpaper",    "Tapete"),
            ("bg_stripes",      "Streifen"),
            ("bg_cremePattern", "Creme Muster"),
            ("bg_sonne",        "Sonne"),
            ("bg_lightBlue",    "Hellblau"),
            ("bg_lightPink",    "Hellrosa"),
            ("bg_SageGreen",    "Salbeigrün"),
            ("bg_lightGreen",   "Hellgrün")
        ]
        
        for (name, display) in backgrounds {
            repository.seedImage(type: "background", name: name, displayName: display)
        }
        
        print("✅ Seeds geladen!")
    }
}
