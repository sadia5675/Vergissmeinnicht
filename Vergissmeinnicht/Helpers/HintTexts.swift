//
//  HintTexts.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 25.05.26.
//

import Foundation

struct HintTexts {
    
    static let motivational = [
        "✨ Deine Beziehung mit @NAME blüht! Du machst das wunderbar!",
        "🌱 @NAME ist ein wichtiger Teil deines Gartens - und du pflegst sie mit Liebe!",
        "💚 Deine Aufmerksamkeit für @NAME macht einen echten Unterschied!",
        "🌿 Eine gut gepflegte Beziehung - genau wie ein gepflegter Garten!",
        "✅ Du zeigst @NAME, dass sie wertvoll für dich sind. Das ist wunderbar!",
        "💎 Die Zeit, die du in @NAME investierst, prägt eure Beziehung!",
        "🎯 @NAME zu pflegen zeigt, wer du bist - jemand der sich kümmert!",
        "🌸 Eine Beziehung voller Bedeutung - genau das, was du aufbaust!",
        "💭 Deine bewusste Pflege von @NAME macht sie stärker und tiefer!",
        "✨ Du schaffst einen Raum, wo @NAME sich gesehen und wichtig fühlt!"
    ]
    
    static let gentleReminder = [
        (display: "💭 Zeit für @NAME?", prefilled: "Hey @NAME! 👋"),
        (display: "🔔 @NAME wartet auf dich!", prefilled: "Wie geht's dir, @NAME?"),
        (display: "📲 Kontaktier @NAME!", prefilled: "Hey @NAME, lange nicht gesprochen! 💚")
    ]
    
    static let missingYou = [
        "😔 Kannst du dich noch erinnern? @MOMENT",
        "💔 @NAME vermisst dich... Du schriebst damals: '@MOMENT'",
        "🥺 Heute vor @DAYS Tagen notiertest du: '@MOMENT'",
        "💭 Erinnerst du dich noch an: '@MOMENT'?"
    ]
    
    static func replace(text: String, with name: String) -> String {
        text.replacingOccurrences(of: "@NAME", with: name)
    }
}
