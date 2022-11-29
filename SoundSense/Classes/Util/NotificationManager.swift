//
//  Notification.swift
//  test
//
//  Created by Andrea  Ongaro on 03/04/22.
//

import Foundation
import UserNotifications


final class NotificationManager: ObservableObject {
    @Published private(set) var notifications: [UNNotificationRequest] = []
    @Published private(set) var authorizationStatus: UNAuthorizationStatus?
    
    func reloadAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.authorizationStatus = settings.authorizationStatus
            }
        }
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { isGranted, _ in
            DispatchQueue.main.async {
                self.authorizationStatus = isGranted ? .authorized : .denied
            }
        }
    }
    
    func reloadLocalNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            DispatchQueue.main.async {
                self.notifications = notifications
            }
        }
    }

    
    func createLocalNotification(title: String, hour: Int, minute: Int, weekDay: Int, completion: @escaping (Error?) -> Void) {
            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = minute
            dateComponents.weekday = weekDay
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = title + " " + getStringName(id: weekDay)
            notificationContent.sound = .default
            //notificationContent.userInfo  = ["customData": "Some Data"]
            notificationContent.body = "Sonifica ora i tuoi dati!"
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: completion)
        }
    
    func deleteLocalNotifications(identifiers: [String]) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    func getStringName(id: Int) -> String {
        switch id {
            case 2:
                return "Martedì"
            case 3:
                return "Mercoledì"
            case 4:
                return "Giovedì"
            case 5:
                return "Venerdì"
            case 6:
                return "Sabato"
            case 7:
                return "Domenica"
            case 1:
                return "Lunedì"
        default:
            return "Non Impostato"
        }
    }
}


enum ExampleError: Error {
    case invalid
    case uncorrect
}
