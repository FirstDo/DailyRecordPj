//
//  SceneDelegate.swift
//  DailyRecordProject
//
//  Created by DuDu on 2021/09/28.
//

import UIKit
import UserNotifications

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = TabBarViewController()
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] setting in
            switch setting.authorizationStatus {
            case .authorized:
                self?.reservePushNoti()
            case .denied:
                self?.removePushNoti()
            default:
                break
            }
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) { }
}

extension SceneDelegate {
    private func reservePushNoti() {
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
        
        UNUserNotificationCenter.current().add(request) { _ in }
        UserDefaults.standard.set(true, forKey: UserDefaultKey.switchState)
        NotificationCenter.default.post(name: .pushChanged, object: nil)
    }

    private func removePushNoti() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UserDefaults.standard.set(false, forKey: UserDefaultKey.switchState)
        NotificationCenter.default.post(name: .pushChanged, object: nil)
    }
}
