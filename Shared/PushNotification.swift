//
//  PushNotification.swift
//  DailyRecordProject
//
//  Created by 김도연 on 2021/11/27.
//

import Foundation
import UserNotifications
import NotificationCenter

func reservePushNoti() {
    print("reservePushNoti")
    let content = UNMutableNotificationContent()
    content.title = "제목입니다"
    content.body = "내용입니다"
    content.badge = 1
    content.sound = UNNotificationSound.default
    
    var dateComponents = DateComponents()
    dateComponents.hour = 22
    dateComponents.minute = 0
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    let request = UNNotificationRequest(identifier: "alarm", content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print(error)
        } else {
            print("Done")
        }
    }
    UserDefaults.standard.set(true, forKey: UserDefaultKey.switchState)
    NotificationCenter.default.post(name: .pushChanged, object: nil)
}

func removePushNoti() {
    print("removePushNoti")
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    UserDefaults.standard.set(false, forKey: UserDefaultKey.switchState)
    NotificationCenter.default.post(name: .pushChanged, object: nil)
}

