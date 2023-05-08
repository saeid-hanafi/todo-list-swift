//
//  NotificationManager.swift
//  todoList
//
//  Created by Macvps on 5/7/23.
//

import Foundation
import UserNotifications

class NotificationManager {
    var notifications = [NotificationData]()
    
    func getPenddingNotifications() {
        UNUserNotificationCenter.current()
            .getPendingNotificationRequests { notifications in
                for notification in notifications {
                    print("pending notification is : \(notification.identifier)")
                }
            }
    }
    
    private func notificationAuthorization() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                if granted == true && error == nil {
                    self.notificationSchedules()
                }
            }
    }
    
    func schedules() {
        UNUserNotificationCenter.current()
            .getNotificationSettings { settings in
                switch settings.authorizationStatus {
                    case .notDetermined:
                        self.notificationAuthorization()
                        break
                case .authorized, .provisional:
                        self.notificationSchedules()
                        break
                    default:
                        break
                }
            }
    }
    
    private func notificationSchedules() {
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.subtitle = notification.subTitle
            content.sound = .default
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: notification.dateTime, repeats: false)
            
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) {
                error in
                guard error == nil else {
                    return
                }
//                print("notification id is : \(notification.id)")
            }
        }
    }
    
    func removeNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
