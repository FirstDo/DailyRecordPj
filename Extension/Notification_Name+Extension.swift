//
//  Notification_Name+Extension.swift
//  DailyRecordProject
//
//  Created by DuDu on 2022/03/13.
//

import Foundation

extension Notification.Name {
    static let reloadListData = Notification.Name("reloadListData")
    static let listDataChanged = Notification.Name("listDataChanged")
    
    static let dataChanged = Notification.Name("dataChanged")
    
    static let weekChanged = Notification.Name("weekChanged")
    
    static let pushChanged = Notification.Name("pushChanged")
}
