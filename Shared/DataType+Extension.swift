//  DataType+Extension.swift
//  여러 type들의 extension을

import Foundation

//list page의 month, year를 선택했을때, view를 다시 보여주기 위한 Notification
extension Notification.Name {
    static let reloadListData = Notification.Name("reloadListData")
    static let listDataChanged = Notification.Name("listDataChanged")
    
    static let dataChanged = Notification.Name("dataChanged")
}

//current Year Month를 얻을 수 있는 extension
extension Date {
    static var year: Int16 {
        let curDate = Calendar.current.dateComponents([.year], from: Date())
        return Int16(curDate.year!)
    }
    
    static var month: Int16 {
        let curDate = Calendar.current.dateComponents([.month], from: Date())
        return Int16(curDate.month!)
    }
}


