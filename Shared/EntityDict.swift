//
//  EntityDict.swift
//  DailyRecordProject
//
//  Created by 김도연 on 2021/11/16.
//

import Foundation

class EntityDict {
    static let shared = EntityDict()
    var listDict = [Int: DailyInfoEntity]()
}
