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
        
    }

    override func tearDownWithError() throws {
        
    }
    
    // MARK: - DailyRecordBuilder Test
    
    func test_DailyRecordBuilder가_DailyRecord를_제대로_만드는지() {
        // given
        DailyRecordBuilder.shared.reset()
        
        // when
        let dailyRecord = DailyRecordBuilder.shared
            .setMood(.angry)
            .setGoodWork("좋은일")
            .setBadWork("나쁜일")
            .setThanksWork("고마운일")
            .setHighlight("개발하기")
            .make()
    
        // then
        XCTAssertEqual(dailyRecord.mood, Mood.angry)
        XCTAssertEqual(dailyRecord.goodWork, "좋은일")
        XCTAssertEqual(dailyRecord.badWork, "나쁜일")
        XCTAssertEqual(dailyRecord.thanksWork, "고마운일")
        XCTAssertEqual(dailyRecord.highlight, "개발하기")
    }
    
    // MARK: - CoreDataTest
    
}
