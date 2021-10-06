/*
 데이터 저장을 위한 singleton class
 유저의 입력을 저장해 놨다가, 마지막 highlight를 저장할때 저장된 데이터를 읽어오는데 쓰인다.
 */

import Foundation

//for userInputData
class UserInputData {
    var date: String?
    var mood: String?
    var goodThing: String?
    var badThing: String?
    var thanksThing: String?
    var highlightThing: String?
    
    var month: Int16?
    var year: Int16?
    
    static let shared = UserInputData()
    private init () {}
    
    func setData(date: String?, mood: String?, good: String?, bad: String?, thanks: String?, highlight: String?, month: Int16?, year: Int16?) {
        self.date = date
        self.mood = mood
        self.goodThing = good
        self.badThing = bad
        self.thanksThing = thanks
        self.highlightThing = highlight
        
        self.month = month
        self.year = year
    }
    
    func cleanData() {
        self.date = nil
        self.mood = nil
        self.goodThing = nil
        self.badThing = nil
        self.thanksThing = nil
        self.highlightThing = nil
        self.month = nil
        self.year = nil
    }
    
    func getAllData() -> (String,String,String,String,String,String,Int16,Int16)? {
        guard let date = date, let mood = mood, let goodThing = goodThing, let badThing = badThing, let thanksThing = thanksThing, let highlight = highlightThing, let month = month, let year = year else {
            return nil
        }
        
        return (date, mood, goodThing, badThing, thanksThing, highlight, month,year)
    }
}
