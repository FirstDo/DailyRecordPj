//
//  DailyRecordBuilder.swift
//  DailyRecordProject
//
//  Created by dudu on 2022/06/17.
//

import Foundation

final class DailyRecordBuilder {
    static let shared = DailyRecordBuilder()
    private init() {}
    
    private var userRecord = DailyRecord()
    
    func reset(with userRecord: DailyRecord = DailyRecord()) {
        self.userRecord = userRecord
    }
    
    func setDate(_ date: Date) -> Self {
        userRecord.createdDate = date
        return self
    }
    
    func setMood(_ mood: Mood) -> Self {
        userRecord.mood = mood
        return self
    }
    
    func setGoodWork(_ text: String) -> Self {
        userRecord.goodWork = text
        return self
    }
    
    func setBadWork(_ text: String) -> Self {
        userRecord.badWork = text
        return self
    }
    
    func setThanksWork(_ text: String) -> Self {
        userRecord.thanksWork = text
        return self
    }
    
    func setHighlight(_ text: String) -> Self {
        userRecord.highlight = text
        return self
    }
    
    func make() -> DailyRecord {
        defer {
            reset()
        }
        
        return userRecord
    }
}
