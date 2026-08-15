//
//  Texts.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 20.06.26.
//

/// Wurzelstruktur der aus der JSON-Datei geladenen Texte
/// 
/// Für Hinweise, Benachrichtigungen und Statusmeldungen
struct Texts: Codable {
    let hints: HintTextsData
    let notifications: NotificationTexts
    let status: StatusTexts
}

struct HintTextsData: Codable {
    let motivational: [String]
    let gentleReminder: [GentleReminder]
    let missingYou: [String]
}

struct GentleReminder: Codable {
    let display: String
    let prefilled: String
}

struct NotificationTexts: Codable {
    let intervalTitle: String
    let intervalBody: [String]
    let birthdayTitle: String
    let birthdayBody: String
    let customBody: String
}

struct StatusTexts: Codable {
    let blooming: String
    let needsCare: String
    let missesYou: String
}
