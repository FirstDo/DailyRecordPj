//
//  DailyRecord.swift
//  DailyRecordProject
//
//  Created by dudu on 2022/06/17.
//

import Foundation

struct DailyRecord: Hashable {
    var mood: Mood?
    var goodWork: String?
    var badWork: String?
    var thanksWork: String?
    var highlight: String?
    var createdDate: Date? = Date()
}

enum Mood: Int {
    case happy = 0
    case sad = 1
    case soso = 2
    case angry = 3
}
