//
//  NotificationService.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 21.05.26.
//

import UserNotifications
import Foundation
import UIKit

/// Verwaltet alle lokalen Push-Benachrichtigungen der App: Pflegeintervall Erinnerungen, Geburtstage und benutzerdefinierte Erinnerungen
@MainActor
class NotificationService {

    static let shared = NotificationService()
    private let textService = TextService.shared

    // MARK: - PERMISSION

    /// Fragt den Nutzer einmalig um Erlaubnis für Benachrichtigungen
    func requestNotificationPermission() {
        
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, error in

            if granted {
                print("Notification Permission gewährt!")
            } else if let error = error {
                print("Permission Fehler: \(error)")
            }
        }
    }

    // MARK: - INTERVALL REMINDER

    /// Plant eine Erinnerung zum nächsten fälligen Pflegezeitpunkt
    func scheduleIntervalReminder(for relationship: Relationship) {

        guard !relationship.isResting else {
            return
        }
        var components = Calendar.current.dateComponents(
            [.year, .month, .day],
            from: relationship.careRhythm.nextReminderDate
        )
        
        components.hour = 9
        components.minute = 0
        
        schedule(
            identifier: "interval-\(relationship.id)",
            title: textService.texts.notifications.intervalTitle
                .replacingOccurrences(of: "@NAME", with: relationship.name),
            body: (textService.texts.notifications.intervalBody.randomElement() ?? "")
                .replacingOccurrences(of: "@NAME", with: relationship.name),
            trigger: UNCalendarNotificationTrigger(
                dateMatching: components,
                repeats: false
            )
        )
    }

    /// Storniert die bestehende Intervall-Erinnerung und plant sie mit den aktuellen Werten neu
    func refreshIntervalReminder(for relationship: Relationship) {
        cancel(identifier: "interval-\(relationship.id)")
        scheduleIntervalReminder(for: relationship)
    }

    // MARK: - GEBURTSTAG REMINDER

    /// Plant eine jährlich wiederkehrende Geburtstags-Erinnerung
    func scheduleBirthdayReminder(for relationship: Relationship) {

        guard !relationship.isResting else {
            return
        }
        guard let birthDate = relationship.birthDate else {
            return
        }
        var components = Calendar.current.dateComponents(
            [.month, .day],
            from: birthDate
        )
        components.hour = 9
        components.minute = 0
        
        schedule(
            identifier: "birthday-\(relationship.id)",
            title: textService.texts.notifications.birthdayTitle,
            body: textService.texts.notifications.birthdayBody
                .replacingOccurrences(of: "@NAME", with: relationship.name),
            trigger: UNCalendarNotificationTrigger(
                dateMatching: components,
                repeats: true
            )
        )
    }

    /// Storniert die bestehende Geburtstags-Erinnerung und plant sie neu, falls weiterhin ein Geburtsdatum hinterlegt ist
    func refreshBirthdayReminder(for relationship: Relationship) {
        cancel(identifier: "birthday-\(relationship.id)")
       
        if relationship.birthDate != nil {
            scheduleBirthdayReminder(for: relationship)
        }
    }

    // MARK: - CUSTOM REMINDER

    /// Plant eine benutzerdefinierte Erinnerung zum hinterlegten Zeitpunkt
    func scheduleCustomReminder(_ reminder: CustomReminder, for relationship: Relationship) {

        guard !relationship.isResting else {
            return
        }
        guard reminder.isActive else {
            return
        }
        
        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: reminder.date
        )
        
        schedule(
            identifier: "custom-\(reminder.id)",
            title: reminder.label,
            body: textService.texts.notifications.customBody
                .replacingOccurrences(of: "@NAME", with: relationship.name),
            trigger: UNCalendarNotificationTrigger(
                dateMatching: components,
                repeats: false
            )
        )
    }

    /// Storniert eine bestehende benutzerdefinierte Erinnerung und plant sie neu, sofern sie weiterhin aktiv ist
    func refreshCustomReminder(_ reminder: CustomReminder, for relationship: Relationship) {
        cancel(identifier: "custom-\(reminder.id)")

        if reminder.isActive {
            scheduleCustomReminder(reminder, for: relationship)
        }
    }

    /// Storniert eine benutzerdefinierte Erinnerung endgültig
    func deleteCustomReminder(_ reminder: CustomReminder) {
        cancel(identifier: "custom-\(reminder.id)")
    }

    /// Storniert sämtliche geplanten Benachrichtigungen einer Beziehung
    /// wird beim Eintritt in den Ruhezustand aufgerufen
    func cancelAllNotifications(for relationship: Relationship) {
        cancel(identifier: "interval-\(relationship.id)")
        cancel(identifier: "birthday-\(relationship.id)")
        for reminder in relationship.customReminders {
            cancel(identifier: "custom-\(reminder.id)")
        }
    }

    // MARK: - HELPER

    /// Baut den Notification-Content (Titel, Text, Sound, Badge) und reicht ihn zusammen mit dem übergebenen Trigger und der eindeutigen ID beim System ein
    private func schedule(
        identifier: String,
        title: String,
        body: String,
        trigger: UNCalendarNotificationTrigger
    ) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        // TODO: Badge-Zahl wird hier nur zum Planungszeitpunkt berechnet nicht zum tatsächlichen Zustellungszeitpunkt
        content.badge = NSNumber(
            value: UIApplication.shared.applicationIconBadgeNumber + 1
        ) 
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in

            if let error = error {
                print("Fehler bei Notification \(identifier): \(error)")
            }
        }
    }

    /// Entfernt eine geplante Notification anhand ihrer ID
    private func cancel(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [identifier]
        )
    }
}
