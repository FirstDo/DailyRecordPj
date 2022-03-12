//
//  Date+Extension.swift
//  DailyRecordProject
//
//  Created by DuDu on 2022/03/13.
//

import Foundation

extension Date {
    static var year: Int16 {
        let curDate = Calendar.current.dateComponents([.year], from: Date())
        return Int16(curDate.year ?? 2022)
    }
    
    static var month: Int16 {
        let curDate = Calendar.current.dateComponents([.month], from: Date())
        return Int16(curDate.month ?? 01)
    }
    
    var year: Int16 {
        let comp = Calendar.current.dateComponents([.year], from: self)
        return Int16(comp.year ?? 2022)
    }
    
    var month: Int16 {
        let comp = Calendar.current.dateComponents([.month], from: self)
        return Int16(comp.month ?? 01)
    }
    
    var day: Int16 {
        let comp = Calendar.current.dateComponents([.day], from: self)
        return Int16(comp.day ?? 01)
    }
}
