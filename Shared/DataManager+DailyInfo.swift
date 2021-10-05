//
//  DataManager+DailyInfo.swift
//  DailyRecordProject
//
//  Created by 김도연 on 2021/10/05.
//

import Foundation
import CoreData

extension DataManager {
    func createDailyInfo(date: String, mood: String, good: String, bad: String, thanks: String, highlight: String, completion: (() -> ())? = nil) {
        mainContext.perform {
            print("CREATE")
            let newTask = DailyInfoEntity(context: self.mainContext)
            newTask.date = date
            newTask.good = good
            newTask.bad = bad
            newTask.thanks = thanks
            newTask.mood = mood
            newTask.highlight = highlight
            
            self.saveContent()
            completion?()
        }
    }
    
    func fetchTask(_ month: Int) -> [DailyInfoEntity] {
        print("FETCH")
        var list = [DailyInfoEntity]()
        
        mainContext.performAndWait {
            let request: NSFetchRequest<DailyInfoEntity> = DailyInfoEntity.fetchRequest()
            
            do {
                list = try mainContext.fetch(request)
            } catch {
                print(error.localizedDescription)
            }
        }
        print("list: ",list)
        return list
    }
    
    func updateTask(entity: DailyInfoEntity, date: String, mood: String, good: String, bad: String, thanks: String, highlight: String, completion: (()->())? = nil) {
        mainContext.perform {
            
            entity.date = date
            entity.mood = mood
            entity.good = good
            entity.bad = bad
            entity.thanks = thanks
            entity.highlight = highlight
            
            
            self.saveContent()
            completion?()
            print("UPDATE")
        }
    }
    
    func deleteTask(entity: DailyInfoEntity, completion: (()->())? = nil) {
        mainContext.perform {
            print("DELETE")
            self.mainContext.delete(entity)
            self.saveContent()
            completion?()
        }
    }
    
}
