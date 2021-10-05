//
//  UserInput.swift
//  DailyRecordProject
//
//  Created by 김도연 on 2021/09/29.
//

import Foundation

//for userInputData
class UserInputData {
    var mood: String?
    var goodThing: String?
    var badThing: String?
    var thanksThing: String?
    var highlightThing: String?
    
    static let shared = UserInputData()
    private init () {}
    
    func cleanData() {
        self.mood = nil
        self.goodThing = nil
        self.badThing = nil
        self.thanksThing = nil
        self.highlightThing = nil
    }
    
    func getAllData() -> [String] {
        guard let mood = mood, let goodThing = goodThing, let badThing = badThing, let thanksThing = thanksThing, let highlight = highlightThing else {
            
            return [String]()
        }
        
        return [mood, goodThing, badThing, thanksThing, highlight]
    }
}
