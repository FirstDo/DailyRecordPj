//
//  DailyRecordProjectTests.swift
//  DailyRecordProjectTests
//
//  Created by dudu on 2022/06/17.
//

import XCTest
@testable import DailyRecordProject

class DailyRecordProjectTests: XCTestCase {
    
    override func setUpWithError() throws {
        PersistantManager.shared.deleteAll()
        DailyRecordBuilder.shared.reset()
    }

    override func tearDownWithError() throws {
        PersistantManager.shared.deleteAll()
        DailyRecordBuilder.shared.reset()
    }
    
    // MARK: - DailyRecordBuilder Test
    
    private func makeSample(with date: Date) -> DailyRecord {
        return DailyRecordBuilder.shared
                .setMood(.angry)
                .setGoodWork("좋은일")
                .setBadWork("나쁜일")
                .setThanksWork("고마운일")
                .setHighlight("개발하기")
                .setDate(date)
                .make()
    }
    
    func test_DailyRecordBuilder가_DailyRecord를_제대로_만드는지() {
        // given
        
        // when
        let dailyRecord = makeSample(with: Date.now)
    
        // then
        XCTAssertEqual(dailyRecord.mood, Mood.angry)
        XCTAssertEqual(dailyRecord.goodWork, "좋은일")
        XCTAssertEqual(dailyRecord.badWork, "나쁜일")
        XCTAssertEqual(dailyRecord.thanksWork, "고마운일")
        XCTAssertEqual(dailyRecord.highlight, "개발하기")
    }
    
    // MARK: - CoreDataTest
    
    func test_DailyRecord가_CoreData에_제대로저장되는지() {
        // given
        let dailyRecord = makeSample(with: Date.now)
        
        // when
        PersistantManager.shared.create(userRecord: dailyRecord)
        let result = PersistantManager.shared.fetchAll(target: Date.now)?.first!
        
        // then
        XCTAssertEqual(dailyRecord, result)
    }
    
    func test_CoreData저장소에서_특정날짜만_Fetch되는지() {
        // given
        var dateComponet = DateComponents(calendar: .current, year: 2022, month: 6, day: 17)
        let today = makeSample(with: dateComponet.date!)
        
        dateComponet.day = 18
        let nextDay = makeSample(with: dateComponet.date!)
        
        PersistantManager.shared.create(userRecord: today)
        PersistantManager.shared.create(userRecord: nextDay)
        
        // when
        let result = PersistantManager.shared.fetch(date: dateComponet.date!)!
        
        // then
        XCTAssertEqual(nextDay.createdDate!, result.createdDate!)
    }
    
    func test_CoreData저장소에서_특정년도_특정월만_Fetch되는지() {
        // given
        var dateComponent = DateComponents(calendar: .current, year: 2022, month: 6, day: 17)
        let today = makeSample(with: dateComponent.date!)
        
        dateComponent.day = 18
        let nextDay = makeSample(with: dateComponent.date!)
        
        dateComponent.month = 7
        let nextMonth = makeSample(with: dateComponent.date!)
        
        dateComponent.month = 8
        let nnextMonth = makeSample(with: dateComponent.date!)
        
        dateComponent.month = 9
        let nnnextMonth = makeSample(with: dateComponent.date!)
        
        PersistantManager.shared.create(userRecord: today)
        PersistantManager.shared.create(userRecord: nextDay)
        PersistantManager.shared.create(userRecord: nextMonth)
        PersistantManager.shared.create(userRecord: nnextMonth)
        PersistantManager.shared.create(userRecord: nnnextMonth)
        
        // when
        let result = PersistantManager.shared.fetchAll(target: today.createdDate!)!
        
        // then
        
        XCTAssertEqual(result.count, 2)
    }
}
