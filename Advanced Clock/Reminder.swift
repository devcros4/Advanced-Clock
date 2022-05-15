//
//  Reminder.swift
//  Advanced Clock
//
//  Created by jean-baptiste delcros on 01/05/2022.
//

import Foundation
import UserNotifications

protocol ReminderDelegate {
    func onReminderfired(_ reminder: Reminder) -> Void
}


class Reminder {
    private typealias Notification = UNNotificationRequest
    
    var timer: Timer!
    var title: String!
    var descr: String?
    var tag: Int?
    var fireDate: Date
    var delegate: ReminderDelegate?
    
    init(_ title: String, description descr: String? = nil, fireOnDate date: Date, tag: Int? = nil) {
        self.title = title
        self.fireDate = date
        self.tag = tag
        self.descr = descr
        let id = "test"
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = "Hey! Your timer has fired"
        content.body = self.descr ?? ""
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: date.timeIntervalSinceNow, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                if let d = self.delegate {
                    d.onReminderfired(self)
                }
            }
        }
            
    }
}
