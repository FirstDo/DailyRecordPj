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
    let content = UNMutableNotificationContent()
    content.title = "하루기록"
    content.body = "오늘의 하루를 기록하세요"
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
        }
    }
    UserDefaults.standard.set(true, forKey: UserDefaultKey.switchState)
    NotificationCenter.default.post(name: .pushChanged, object: nil)
}

func removePushNoti() {
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    UserDefaults.standard.set(false, forKey: UserDefaultKey.switchState)
    NotificationCenter.default.post(name: .pushChanged, object: nil)
}

