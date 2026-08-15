//
//  HintDismissalStore.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 04.07.26.
//

import Foundation

/// Merkt sich, wann ein Hint zuletzt weggewischt wurde
///
/// Gespeichert in UserDefaults, damit es App-Neustarts übersteht
///
/// Ein weggewischter Hint bleibt für den restlichen Tag versteckt und ist am nächsten Tag automatisch wieder erlaubt
@MainActor
final class HintDismissalStore {

    static let shared = HintDismissalStore()
    private let defaultsKey = "dismissedHintDates"
    
    private var dismissals: [UUID: Date] {
        get {
            guard let data = UserDefaults.standard.data(forKey: defaultsKey),
                  let decoded = try? JSONDecoder().decode(
                    [UUID: Date].self,
                    from: data
                  )
            else {
                return [:]
            }
            return decoded
        }

        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                return
            }
            UserDefaults.standard.set(data, forKey: defaultsKey)
        }
    }

    /// Merkt sich, dass der Hint für diese Beziehung heute weggewischt wurde
    func dismiss(_ relationshipId: UUID) {

        var current = dismissals
        current[relationshipId] = Date()
        dismissals = current
    }

    /// Gibt an, ob der Hint für diese Beziehung heute bereits weggewischt wurde
    /// 
    /// An einem neuen Kalendertag automatisch wieder false
    func isDismissedToday(_ relationshipId: UUID) -> Bool {
        
        guard let date = dismissals[relationshipId] else {
            return false
        }
        return Calendar.current.isDateInToday(date)
    }
}
