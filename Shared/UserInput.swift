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
    var highlight: String?
    
    static let shared = UserInputData()
    private init () {}
    
    func cleanData() {
        self.mood = nil
        self.goodThing = nil
        self.badThing = nil
        self.thanksThing = nil
        self.highlight = nil
    }
    
    func getData() -> [String] {
        guard let mood = mood, let goodThing = goodThing, let badThing = badThing, let thanksThing = thanksThing, let highlight = highlight else {
            
            return [String]()
        }
        
        return [mood, goodThing, badThing, thanksThing, highlight]
    }
}
