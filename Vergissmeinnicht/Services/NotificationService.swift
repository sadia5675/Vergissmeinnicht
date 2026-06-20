//
//  NotificationService.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 21.05.26.
//

import UserNotifications
import Foundation
import UIKit

@MainActor
class NotificationService {
    static let shared = NotificationService()
    
    // MARK: - PERMISSION
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification Permission gewährt!")
            } else if let error = error {
                print("Permission Fehler: \(error)")
            }
        }
    }
    
    // MARK: - INTERVALL REMINDER
    
    func scheduleIntervalReminder(for relationship: Relationship) {
        guard let nextReminderDate = relationship.careRhythm.nextReminderDate else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Zeit für \(relationship.name)!"
        content.body = "Melde dich bei \(relationship.name). Eure Beziehung ist dir wichtig!"
        content.sound = .default
        content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        
        // Trigger: zu nextReminderDate
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: nextReminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "interval-\(relationship.id)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Fehler bei Notification: \(error)")
            } else {
                print("Interval Reminder geplant für \(relationship.name)")
            }
        }
    }
    
    func refreshIntervalReminder(
        for relationship: Relationship
    ) {

        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(
                withIdentifiers: [
                    "interval-\(relationship.id)"
                ]
            )

        scheduleIntervalReminder(
            for: relationship
        )
    }
    
    // MARK: - GEBURTSTAG REMINDER
    
    func scheduleBirthdayReminder(for relationship: Relationship) {
        guard let birthDate = relationship.birthDate else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Herzlichen Glückwunsch!"
        content.body = "Heute ist \(relationship.name)s Geburtstag! Schreib ihr eine Nachricht!"
        content.sound = .default
        content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        
        // Trigger: jedes Jahr am Geburtstag (Monat + Tag)
        var components = Calendar.current.dateComponents([.month, .day], from: birthDate)
        components.hour = 9  // 9 Uhr morgens
        components.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "birthday-\(relationship.id)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Fehler bei Birthday Notification: \(error)")
            } else {
                print("Birthday Reminder geplant für \(relationship.name)")
            }
        }
    }
    
    func refreshBirthdayReminder(
        for relationship: Relationship
    ) {

        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(
                withIdentifiers: [
                    "birthday-\(relationship.id)"
                ]
            )

        if relationship.birthDate != nil {

            scheduleBirthdayReminder(
                for: relationship
            )
        }
    }
    
    // MARK: - CUSTOM REMINDER

    func scheduleCustomReminder(_ reminder: CustomReminder, for relationship: Relationship) {
        guard reminder.isActive else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "\(reminder.label)"
        content.body = "Erinnerung für \(relationship.name)"
        content.sound = .default
        content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        
        // Trigger: zu reminder.date
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminder.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "custom-\(reminder.id)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Fehler bei Custom Reminder: \(error)")
            } else {
                print("Custom Reminder geplant: \(reminder.label)")
            }
        }
    }
    
    
    func refreshCustomReminder(
        _ reminder: CustomReminder,
        for relationship: Relationship
    ) {

        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(
                withIdentifiers: [
                    "custom-\(reminder.id)"
                ]
            )

        if reminder.isActive {

            scheduleCustomReminder(
                reminder,
                for: relationship
            )
        }
    }
    
    func deleteCustomReminder(
        _ reminder: CustomReminder
    ) {

        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(
                withIdentifiers: [
                    "custom-\(reminder.id)"
                ]
            )
    }
    
}
