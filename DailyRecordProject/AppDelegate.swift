//
//  AppDelegate.swift
//  DailyRecordProject
//
//  Created by DuDu on 2021/09/28.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        setUpCoreDataModel()
        requestNotificationAuthorization()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) { }
}

extension AppDelegate {
    private func setUpCoreDataModel() {
        let coreDataModelName = "DailyInfoModel"
        DataManager.shared.setUp(modelName: coreDataModelName)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    private func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { granted, error in
            
            if granted {
                UNUserNotificationCenter.current().delegate = self
            }
        }
    }
}

