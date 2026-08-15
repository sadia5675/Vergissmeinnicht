//
//  DateFormatter+Relationship.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 09.06.26.
//

import Foundation

/// Formatiert Datumsangaben
struct DateTextFormatter {

    // MARK: - Days Since

    static func formatDaysSince(_ days: Int) -> String {
        if days == 0 {
            return "heute"
        } else if days == 1 {
            return "gestern"
        } else {
            return "vor @DAYS Tagen"
                .replacingOccurrences(
                    of: "@DAYS",
                    with: "\(days)"
                )
        }
    }

    // MARK: - Moment Date

    static func formatMomentDate(_ date: Date) -> String {
        let calendar = Calendar.current

        if calendar.isDateInToday(date) {
            return "heute"
        }
        if calendar.isDateInYesterday(date) {
            return "gestern"
        }
        return date.formatted(
            date: .long,
            time: .omitted
        )
    }

    // MARK: - Last Moment

    /// Zeigt einen Platzhaltertext, falls noch kein Moment dokumentiert wurde
    static func formatLastMoment(_ date: Date?) -> String {

        guard let date else {
            return "Noch kein gemeinsamer Moment"
        }
        return formatMomentDate(date)
    }
}
